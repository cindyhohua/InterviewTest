//
//  FriendsListTableViewCell.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//
import UIKit

class FriendsListTableViewCell: UITableViewCell {
    private let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .textStyle3
        label.textColor = .greyishBrown
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteThree
        return view
    }()
    
    private let likedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icFriendsStar"), for: .normal)
        return button
    }()
    
    private let trasferButton: UIButton = {
       let button = UIButton()
        button.setTitle("轉帳", for: .normal)
        button.setTitleColor(.kokoPink, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.textStyle5
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.kokoPink.cgColor
        return button
    }()
    
    private let pendingButton: UIButton = {
        let button = UIButton()
        button.setTitle("邀請中", for: .normal)
        button.setTitleColor(.brownGrey, for: .normal)
        button.titleLabel?.font = UIFont.textStyle5
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.pinkishGrey.cgColor
        return button
    }()
    
    private let friendMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icFriendsMore_2"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(circularImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(seperatorView)
        circularImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).offset(50)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(40)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(circularImageView.snp.trailing).offset(15)
            make.centerY.equalTo(contentView)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(contentView).offset(105)
            make.trailing.equalTo(contentView).offset(-30)
            make.bottom.equalTo(contentView)
        }
    }

    func configureWithoutImage(name: String, liked: Bool) {
        circularImageView.image = UIImage(named: "imgFriendsList")
        nameLabel.text = name
        switch liked {
        case true: likedFriend()
        case false: likedButton.removeFromSuperview()
        }
    }
    
    func configurePending(pending: Bool) {
        pendingButton.removeFromSuperview()
        trasferButton.removeFromSuperview()
        friendMoreButton.removeFromSuperview()
        switch pending {
        case true:
            setupPendingTransferButton()
        case false:
            setupFriendTransferButton()
        }
    }

    private func likedFriend() {
        contentView.addSubview(likedButton)
        likedButton.snp.makeConstraints { make in
            make.height.width.equalTo(14)
            make.leading.equalTo(contentView).offset(30)
            make.centerY.equalTo(contentView)
        }
    }
    
    private func setupPendingTransferButton() {
        contentView.addSubview(pendingButton)
        pendingButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-20)
            make.height.equalTo(24)
        }
        contentView.addSubview(trasferButton)
        trasferButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(pendingButton.snp.leading).offset(-10)
            make.height.equalTo(24)
        }
    }
    private func setupFriendTransferButton() {
        contentView.addSubview(friendMoreButton)
        friendMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-30)
        }
        contentView.addSubview(trasferButton)
        trasferButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(friendMoreButton.snp.leading).offset(-25)
            make.height.equalTo(24)
        }
    }
}

