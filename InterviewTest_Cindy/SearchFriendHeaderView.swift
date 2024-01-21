//
//  SearchFriendHeaderView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit

class SearchFriendHeaderView: UIView {
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let button = UIButton()
        textField.attributedPlaceholder = NSAttributedString(
            string: "想轉一筆給誰呢？",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.steel,
                NSAttributedString.Key.font : UIFont.textStyle5
            ])
        textField.backgroundColor = .steel12
        textField.layer.cornerRadius = 10
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(32, 0, 0)
        textField.isUserInteractionEnabled = true
        textField.addSubview(button)
        button.setImage(
            UIImage(named: "icSearchBarSearchGray"),
            for: .normal)
        button.snp.makeConstraints { make in
            make.trailing.equalTo(textField.snp.leading).offset(-8)
            make.width.height.equalTo(14)
            make.centerY.equalTo(textField)
        }
        return textField
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(searchTextField)
        addSubview(addFriendButton)
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(36)
            make.top.equalToSuperview()
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.leading.equalTo(searchTextField.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-30)
            make.height.width.equalTo(24)
            make.centerY.equalTo(searchTextField)
        }
    }
}

