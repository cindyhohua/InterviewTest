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
    var pendingList: [Response] = []
    
    let tableView = UITableView()
    
    let rectangleView: UIView = {
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
    
    lazy var segmentView = SegmentView(
        frame: CGRect(x: 0, y: 0, width: 148, height: 44),
        buttonTitle: ["好友", "聊天"])
    
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
                switch error {
                 case .invalidURL:
                     print("Invalid URL error")
                 case .noData:
                     print("No data received error")
                 case .jsonParsingError(let parseError):
                     print("JSON parsing error: \(parseError)")
                 }
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
                            self.pendingList.append(data)
                        } else {
                            self.friendList.append(data)
                        }
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                switch error {
                 case .invalidURL:
                     print("Invalid URL error")
                 case .noData:
                     print("No data received error")
                 case .jsonParsingError(let parseError):
                     print("JSON parsing error: \(parseError)")
                 }
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
        rectangleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(250)
        }
        view.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(rectangleView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(1)
        }
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
        rectangleView.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.bottom.equalTo(rectangleView.snp.bottom)
            make.leading.equalTo(view).offset(10)
            make.height.equalTo(35)
            make.width.equalTo(148)
        }
    }
    
    @objc func buttonTapped() {
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = SearchFriendHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.register(
            FriendsListTableViewCell.self,
            forCellReuseIdentifier: "friendList")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(rectangleView.snp.bottom).offset(1)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "friendList",
            for: indexPath) as? FriendsListTableViewCell else {
            fatalError("Cant find cell")
        }
        cell.selectionStyle = .none
        let friend = friendList[indexPath.row]
        switch friend.isTop {
        case "0":
            cell.configureWithoutImage(name: friend.name, liked: false)
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

