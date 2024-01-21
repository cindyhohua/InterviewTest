//
//  FooterTableView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/21.
//

import UIKit
class FooterView: UIView {
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteThree
        return view
    }()
    
    lazy var segmentView = SegmentView(
        frame: CGRect(x: 0, y: 0, width: 148, height: 44),
        buttonTitle: ["好友", "聊天"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = .whiteTwo
        addSubview(seperatorView)
        seperatorView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(1)
        }
        addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.height.equalTo(35)
            make.width.equalTo(148)
        }
    }
}
