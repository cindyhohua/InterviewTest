//
//  ViewController.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit

class FriendsViewController: UIViewController {
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle4
        label.textColor = UIColor.greyishBrown
        label.text = "庫洛洛·魯西魯"
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle
        label.textColor = UIColor.greyishBrown
        label.text = "KOKO ID：幻影旅團團長"
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "庫洛洛頭貼")
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
        print("qqq")
        setupNavigationItem()
        addRectangleView()
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
            make.height.equalTo(44)
            make.width.equalTo(148)
        }
        
    }
    
    @objc func buttonTapped() {
        
    }


}

