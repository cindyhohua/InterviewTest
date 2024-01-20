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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.realWhite
        print("qqq")
        addView()
    }
    
    func addView() {
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
        view.addSubview(rectangleView)
        rectangleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(270)
        }
        view.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(rectangleView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(1)
        }
    }
    
    @objc func buttonTapped() {
        
    }


}

