//
//  ChooseAPIViewController.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/21.
//

import UIKit
import SnapKit

class ChooseAPIViewController: UIViewController {
    private let friend12Button = createButton(title: Condition.onlyFriendsData.rawValue, tag: 0)
    private let friend3Button = createButton(title: Condition.friendsDataAndRequest.rawValue, tag: 1)
    private let friend4Button = createButton(title: Condition.noData.rawValue, tag: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    static func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 20
        button.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        button.addTarget(nil, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tag = tag
        return button
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        [friend12Button, friend3Button, friend4Button].forEach {
            $0.backgroundColor = .lightGray
        }
        sender.backgroundColor = .appleGreen
        switch sender.tag {
        case 0:
            updateCondition(.onlyFriendsData)
        case 1:
            updateCondition(.friendsDataAndRequest)
        default:
            updateCondition(.noData)
        }
    }
    
    private func updateCondition(_ newCondition: Condition) {
        let conditionInfo: [String: Any] = ["newCondition": newCondition]
        NotificationCenter.default.post(name: .apiManagerConditionDidChange, object: nil, userInfo: conditionInfo)
    }
    
    func setupButtons() {
        view.addSubview(friend12Button)
        view.addSubview(friend3Button)
        view.addSubview(friend4Button)
        friend12Button.backgroundColor = .appleGreen
        friend3Button.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        friend12Button.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-60)
        }
        friend4Button.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(60)
        }
    }
}
