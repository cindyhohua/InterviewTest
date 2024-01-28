//
//  FriendViewController.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/23.
//

import UIKit
import Combine
import PullToRefreshKit

class FriendViewController: UIViewController {
    var viewModel = FriendsViewModel(apiManager: APIManager())
    private var cancellables = Set<AnyCancellable>()
    private let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTwo
        return view
    }()
    
    lazy var searchHeaderView = SearchFriendHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .realWhite
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(FriendsListTableViewCell.self, forCellReuseIdentifier: "friendList")
        table.register(RequestTableViewCell.self, forCellReuseIdentifier: "requestList")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        addRectangleView()
        setupTableView()
        setupRefreshHeader()
        viewModelBinding()
    }
    


    private func setupNavigationItem() {
        navigationItem.leftBarButtonItems = [createWithdrawButton(), createTransferButton()]
        navigationItem.rightBarButtonItem = createScanButton()
    }

    private func createWithdrawButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw"), style: .plain, target: self, action: #selector(buttonTapped))
    }

    private func createTransferButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer"), style: .plain, target: self, action: #selector(buttonTapped))
    }

    private func createScanButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "icNavPinkScan"), style: .plain, target: self, action: #selector(buttonTapped))
    }

    
    private func addRectangleView() {
        view.addSubview(rectangleView)
        rectangleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func setupRefreshHeader() {
        tableView.configRefreshHeader(container: self) { [weak self] in
            self?.viewModel.fetchFriendData()
        }
    }
    
    private func viewModelBinding() {
        viewModel.$filteredFriendList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        viewModel.$searchBarIsToggled
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        viewModel.fetchUserData()
        viewModel.fetchFriendData()
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
        }
    }

    @objc func buttonTapped() {}
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let identifier = viewModel.searchBarIsToggled ? "friendList" : (indexPath.section == 0 ? "requestList" : "friendList")
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let requestCell = cell as? RequestTableViewCell, !viewModel.searchBarIsToggled && indexPath.section == 0 {
            let request = viewModel.requestList[indexPath.row]
            requestCell.expanded(isExpanded: viewModel.requestList.count == 1 || viewModel.isExpanded)
            requestCell.configureWithoutImage(name: request.name, liked: true)
        } else if let friendCell = cell as? FriendsListTableViewCell {
            let friend = viewModel.filteredFriendList[indexPath.row]
            friendCell.configureWithoutImage(name: friend.name, liked: friend.isTop == "1")
            friendCell.configurePending(pending: friend.status != 1)
        }
        
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.searchBarIsToggled ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.searchBarIsToggled {
            switch section {
            case 0:
                switch viewModel.requestList.count {
                case 0: return 0
                default: return viewModel.isExpanded ? viewModel.requestList.count : 1
                }
            case 1: return viewModel.filteredFriendList.count
            default: return 0
            }
        } else {
            return viewModel.filteredFriendList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: tableView, at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.searchBarIsToggled {
            return searchHeaderView
        }
        switch section {
        case 0:
            let headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
            if let firstUser = viewModel.userData.first {
                headerView.setupLabel(name: firstUser.name, kokoId: firstUser.kokoid ?? "")
            }
            return headerView
        case 1:
            searchHeaderView.delegate = viewModel
            return viewModel.friendList.isEmpty ? NoDataView(frame: .zero) : searchHeaderView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !viewModel.searchBarIsToggled && section == 0 ? 85 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !viewModel.searchBarIsToggled {
            switch section{
            case 0:
                let count = viewModel.friendList.filter { $0.status == 2 }.count
                let view = FooterView(frame: .zero, buttonBadge: [count, 100])
                return view
            default: return nil
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return !viewModel.searchBarIsToggled && section == 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !viewModel.searchBarIsToggled && indexPath.section == 0 else { return }
        viewModel.changeExpended()
        updateUI()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(rectangleView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

