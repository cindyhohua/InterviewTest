//
//  UserHeaderView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/23.
//

import UIKit
class UserHeaderView: UIView {
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle4
        label.textColor = UIColor.brown

        return label
    }()
    
    private var renameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        return button
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textStyle
        label.textColor = UIColor.greyishBrown
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsFemaleDefault")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(name: String, kokoId: String) {
        nameLabel.text = name
        if kokoId != "" {
            idLabel.text = "KOKO ID：" + kokoId
        } else {
            idLabel.text = "設定KOKO ID"
        }
    }
    
    private func setupViews() {
        backgroundColor = .whiteTwo
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(30)
            make.bottom.equalTo(self.snp.centerY).offset(4)
        }
        addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(self.snp.centerY).offset(4)
        }
        addSubview(renameButton)
        renameButton.snp.makeConstraints { make in
            make.leading.equalTo(idLabel.snp.trailing)
            make.width.height.equalTo(18)
            make.centerY.equalTo(idLabel)
        }
        addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-30)
            make.centerY.equalTo(self)
            make.height.width.equalTo(52)
        }
        userImageView.layer.cornerRadius = 26
    }
}

