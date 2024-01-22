//
//  NoDataView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/22.
//

import UIKit

class NoDataView: UIView {
    private let emptyFriendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFriendsEmpty")
        return imageView
    }()
    
    private let addFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧：）"
        label.font = UIFont.textStyle6
        label.textColor = .greyishBrown
        return label
    }()
    
    private let addFriendLittleLabel: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用 KOKO 聊起來！\n 還能互相收付款、發紅包喔：）"
        label.font = UIFont.textStyle
        label.textColor = .brownGrey
        label.numberOfLines = 0
        return label
    }()
    
    private let addFriendButton = GradientButton()
    
    private let setIDLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(
            string: "幫助好友更快找到你？設定 KOKO ID",
            attributes: [
                .font: UIFont.textStyle,
                .foregroundColor: UIColor.brownGrey,
                .kern: 0.0
            ])
        
        let pinkColor = UIColor.kokoPink
        let range = NSRange(location: 10, length: 10) 
        attributedString.addAttributes([
            .foregroundColor: pinkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: pinkColor
        ], range: range)
        
        label.attributedText = attributedString
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = .realWhite
        addSubview(emptyFriendImageView)
        emptyFriendImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(65)
            make.trailing.equalTo(self).offset(-65)
            make.height.equalTo(172)
        }
        
        addSubview(addFriendLabel)
        addFriendLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyFriendImageView.snp.bottom).offset(40)
            make.centerX.equalTo(self)
        }
        addSubview(addFriendLittleLabel)
        addFriendLittleLabel.snp.makeConstraints { make in
            make.top.equalTo(addFriendLabel.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
        addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { make in
            make.top.equalTo(addFriendLittleLabel.snp.bottom).offset(25)
            make.width.equalTo(192)
            make.height.equalTo(40)
            make.centerX.equalTo(self)
        }
        addSubview(setIDLabel)
        setIDLabel.snp.makeConstraints { make in
            make.top.equalTo(addFriendButton.snp.bottom).offset(37)
            make.centerX.equalTo(self)
        }
    }
    
    
}

class GradientButton: UIButton {
    private var gradientLayer: CAGradientLayer!

    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icAddFriendWhite"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        insertGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
        insertGradientLayer()
    }
    
    private func setupButton() {
        setTitle("加好友", for: .normal)
        titleLabel?.font = UIFont.textStyle3
        setTitleColor(.realWhite, for: .normal)
        layer.cornerRadius = 20
        clipsToBounds = false
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.width.equalTo(self.snp.height)
        }
    }
    
    private func insertGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.frogGreen.cgColor, UIColor.booger.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 20
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        layer.shadowColor = UIColor.appleGreen.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
    }
}
