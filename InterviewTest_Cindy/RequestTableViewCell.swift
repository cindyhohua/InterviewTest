//
//  RequestTableViewCell.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/21.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    private let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .realWhite
        view.layer.cornerRadius = 6
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let rectangleSmallerView: UIView = {
        let view = UIView()
        view.backgroundColor = .realWhite
        view.layer.cornerRadius = 6
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }()
    
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
    
    private let requestLabel: UILabel = {
        let label = UILabel()
        label.font = .textStyle
        label.textColor = .brownGrey
        label.text = "邀請你成為好友：）"
        return label
    }()
    
    private let agreeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expanded(isExpanded: Bool) {
        switch isExpanded {
        case true:
            rectangleSmallerView.isHidden = true
        case false:
            rectangleSmallerView.isHidden = false
        }
    }

    private func setupUI() {
        contentView.backgroundColor = .whiteTwo
        contentView.addSubview(rectangleSmallerView)
        rectangleSmallerView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(contentView).offset(40)
            make.height.equalTo(70)
            make.trailing.equalTo(contentView).offset(-40)
        }
        contentView.addSubview(rectangleView)
        rectangleView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-15)
            make.leading.equalTo(contentView).offset(30)
            make.trailing.equalTo(contentView).offset(-30)
            make.height.equalTo(70)
        }
        
        rectangleView.addSubview(circularImageView)
        rectangleView.addSubview(nameLabel)
        rectangleView.addSubview(requestLabel)
        rectangleView.addSubview(agreeButton)
        rectangleView.addSubview(deleteButton)
        circularImageView.snp.makeConstraints { make in
            make.leading.equalTo(rectangleView).offset(15)
            make.centerY.equalTo(rectangleView)
            make.width.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(circularImageView.snp.trailing).offset(15)
            make.bottom.equalTo(rectangleView.snp.centerY).offset(-1)
        }
        requestLabel.snp.makeConstraints { make in
            make.leading.equalTo(circularImageView.snp.trailing).offset(15)
            make.top.equalTo(rectangleView.snp.centerY).offset(1)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(rectangleView)
            make.width.height.equalTo(30)
            make.trailing.equalTo(rectangleView).offset(-15)
        }
        agreeButton.snp.makeConstraints { make in
            make.centerY.equalTo(rectangleView)
            make.width.height.equalTo(30)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-15)
        }
    }

    func configureWithoutImage(name: String, liked: Bool) {
        circularImageView.image = UIImage(named: "imgFriendsList")
        nameLabel.text = name
    }
}
