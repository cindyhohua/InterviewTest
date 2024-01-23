//
//  ViewController.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit
import PullToRefreshKit

class FriendsViewController: UIViewController {
    var userData: [Response] = []
    var friendList: [Response] = []
    var requestList: [Response] = []
    var filteredFriendList: [Response] = []
    var isExpanded: Bool = false
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTwo
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.realWhite
        setupNavigationItem()
        addRectangleView()
        setupTableView()
        fetchUserData()
        fetchFriendData()
        setupRefreshHeader()
    }
    
    private func setupRefreshHeader() {
        tableView.configRefreshHeader(container: self) { [weak self] in
            self?.friendList = []
            self?.requestList = []
            self?.fetchFriendData()
        }
    }
    
    func fetchUserData() {
        APIManager.shared.fetchUserData { result in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.userData = userData
                    print(userData)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFriendData() {
        APIManager.shared.fetchFriendData { result in
            switch result {
            case .success(let friendData):
                DispatchQueue.main.async {
                    friendData.forEach { data in
                        if data.status == 0 {
                            self.requestList.append(data)
                        } else {
                            self.friendList.append(data)
                        }
                    }
                    self.filteredFriendList = self.friendList
                    self.tableView.reloadData()
                    self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupNavigationItem() {
        let withdrawButton = UIBarButtonItem(
            image: UIImage(named: "icNavPinkWithdraw"),
            style: .plain, target: self, action: #selector(buttonTapped))
        let transferButton = UIBarButtonItem(
            image: UIImage(named: "icNavPinkTransfer"),
            style: .plain, target: self, action: #selector(buttonTapped))
        let scanButton = UIBarButtonItem(
            image: UIImage(named: "icNavPinkScan"),
            style: .plain, target: self, action: #selector(buttonTapped))
        navigationItem.leftBarButtonItems = [withdrawButton, transferButton]
        navigationItem.rightBarButtonItem = scanButton
    }
    
    func addRectangleView() {
        view.addSubview(rectangleView)
//        rectangleView.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(view).offset(30)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(35)
//        }
//        rectangleView.addSubview(idLabel)
//        idLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel)
//            make.top.equalTo(nameLabel.snp.bottom).offset(8)
//        }
//        rectangleView.addSubview(userImageView)
//        userImageView.snp.makeConstraints { make in
//            make.trailing.equalTo(view).offset(-30)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(37)
//            make.height.width.equalTo(52)
//        }
//        userImageView.layer.cornerRadius = 26
        rectangleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    @objc func buttonTapped() {}
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .realWhite
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.zero
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.register(
            FriendsListTableViewCell.self,
            forCellReuseIdentifier: "friendList")
        tableView.register(
            RequestTableViewCell.self,
            forCellReuseIdentifier: "requestList")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(rectangleView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch requestList.count {
            case 0: return 0
            default: return self.isExpanded ? requestList.count : 1
            }
        case 1: return filteredFriendList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
            if !userData.isEmpty {
                headerView.setupLabel(name: userData[0].name, kokoId: userData[0].kokoid ?? "")
            }
            return headerView
        case 1:
            if friendList.count != 0 {
                let headerView = SearchFriendHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
                headerView.delegate = self
                return headerView
            } else {
                let headerView = NoDataView(frame: .zero)
                return headerView
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 85
        default:
            if friendList.count != 0 {
                return 60
            } else {
                return 500
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let count = friendList.filter { $0.status == 2 }.count
            let view = FooterView(frame: .zero, buttonBadge: [count, 100])
            return view
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "requestList",
                for: indexPath) as? RequestTableViewCell else {
                fatalError("Cant find cell")
            }
            cell.selectionStyle = .none
            let friend = requestList[indexPath.row]
            if requestList.count == 1 {
                cell.expanded(isExpanded: true)
            } else {
                cell.expanded(isExpanded: self.isExpanded)
            }
            cell.configureWithoutImage(name: friend.name, liked: true)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "friendList",
                for: indexPath) as? FriendsListTableViewCell else {
                fatalError("Cant find cell")
            }
            cell.selectionStyle = .none
            let friend = filteredFriendList[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.isExpanded = !self.isExpanded
            self.tableView.reloadData()
        }
    }
}

extension FriendsViewController: SearchFriendHeaderViewDelegate {
    func didChangeSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredFriendList = friendList
        } else {
            filteredFriendList = friendList.filter { $0.name.contains(searchText) }
        }
        tableView.reloadData()
    }
}

