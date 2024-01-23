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
    private let viewModel = FriendsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTwo
        return view
    }()

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
                print("qq")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch viewModel.requestList.count {
            case 0: return 0
            default: return viewModel.isExpanded ? viewModel.requestList.count : 1
            }
        case 1: return viewModel.filteredFriendList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "requestList",
                for: indexPath) as? RequestTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            let request = viewModel.requestList
            if viewModel.requestList.count == 1 {
                cell.expanded(isExpanded: true)
            } else {
                cell.expanded(isExpanded: viewModel.isExpanded)
            }
            cell.configureWithoutImage(name: request[indexPath.row].name , liked: true)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "friendList",
                for: indexPath) as? FriendsListTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            let friend = viewModel.filteredFriendList[indexPath.row]
            switch friend.isTop {
            case "1":
                cell.configureWithoutImage(name: friend.name, liked: true)
            default:
                cell.configureWithoutImage(name: friend.name, liked: false)
            }
            switch friend.status {
            case 1:
                cell.configurePending(pending: false)
            default:
                cell.configurePending(pending: true)

            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
            let userData = viewModel.userData
            if !userData.isEmpty {
                headerView.setupLabel(name: userData[0].name, kokoId: userData[0].kokoid ?? "")
            }
            return headerView
        case 1:
            if viewModel.friendList.count != 0 {
                let headerView = SearchFriendHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
                headerView.delegate = viewModel
                return headerView
            } else {
                let headerView = NoDataView(frame: .zero)
                return headerView
            }
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0: return 85
        default:
            if viewModel.friendList.count != 0 {
                return 60
            } else {
                return 500
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let count = viewModel.friendList.filter { $0.status == 2 }.count
            let view = FooterView(frame: .zero, buttonBadge: [count, 100])
            return view
        default: return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case 0: return 40
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.changeExpended()
            self.updateUI()
        }
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

