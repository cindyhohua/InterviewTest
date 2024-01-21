//
//  ViewController.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit

class FriendsViewController: UIViewController {
    var friendList: [Response] = []
    var requestList: [Response] = []
    var isExpanded: Bool = false
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTwo
        return view
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTwo
        return view
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteThree
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle4
        label.textColor = UIColor.greyishBrown
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle
        label.textColor = UIColor.greyishBrown
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsFemaleDefault")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.realWhite
        setupNavigationItem()
        addRectangleView()
        setupTableView()
        fetchUserData()
        fetchFriendData()
    }
    
    func fetchUserData() {
        APIManager.shared.fetchUserData { result in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self.nameLabel.text = userData.response[0].name
                    if let kokoid = userData.response[0].kokoid {
                        self.idLabel.text = "KOKO ID：" + kokoid
                    } else {
                        self.idLabel.text = "設定KOKO ID"
                    }
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
                    friendData.response.forEach { data in
                        if data.status == 2 {
                            self.requestList.append(data)
                        } else {
                            self.friendList.append(data)
                        }
                    }
                    self.tableView.reloadData()
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
        rectangleView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(35)
        }
        rectangleView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        rectangleView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(37)
            make.height.width.equalTo(52)
        }
        userImageView.layer.cornerRadius = 26
        rectangleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(idLabel).offset(10)
        }
    }
    
    @objc func buttonTapped() {}
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        view.addSubview(tableView)
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
        case 1: return friendList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 1:
            let headerView = SearchFriendHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 0
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section{
        case 0:
            let view = FooterView()
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
            cell.expanded(isExpanded: self.isExpanded)
            cell.configureWithoutImage(name: friend.name, liked: true)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "friendList",
                for: indexPath) as? FriendsListTableViewCell else {
                fatalError("Cant find cell")
            }
            cell.selectionStyle = .none
            let friend = friendList[indexPath.row]
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
            if indexPath.row == 0 {
                self.isExpanded = !self.isExpanded
                self.tableView.reloadData()
            }
        }
    }
}

