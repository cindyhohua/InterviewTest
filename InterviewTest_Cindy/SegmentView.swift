//
//  SegmentView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit

protocol SegmentControlDelegate {
    func changeToIndex(_ manager: SegmentView ,index: Int)
}

class SegmentView: UIView {
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    var delegate: SegmentControlDelegate?
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func configSelectorView() {
        selectorView = UIView(frame: CGRect(x: 27, y: self.frame.height - 4, width: 20, height: 4))
        selectorView.clipsToBounds = true
        selectorView.layer.cornerRadius = 2
        selectorView.backgroundColor = .kokoPink
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(SegmentView.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(.greyishBrown, for: .normal)
            button.titleLabel?.font = .textStyle
            buttons.append(button)
        }
        buttons[0].setTitleColor(.greyishBrown, for: .normal)
        buttons[0].titleLabel?.font = .textStyle2
    }
    
    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.titleLabel?.font = .textStyle
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                self.delegate?.changeToIndex(self, index: buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition + 27
                }
                btn.titleLabel?.font = .textStyle2
            }
        }
    }
    
    private func updateView() {
        createButton()
        configStackView()
        configSelectorView()
    }
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
}

