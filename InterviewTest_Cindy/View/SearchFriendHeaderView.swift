//
//  SearchFriendHeaderView.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import UIKit
import SnapKit

protocol SearchFriendHeaderViewDelegate: AnyObject {
    func didChangeSearchText(_ searchText: String)
}

class SearchFriendHeaderView: UIView {
    weak var delegate: SearchFriendHeaderViewDelegate?

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "想轉一筆給誰呢？"
        return searchBar
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundColor = .realWhite
        addSubview(searchBar)
        addSubview(addFriendButton)
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(36)
            make.top.equalToSuperview()
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.leading.equalTo(searchBar.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-30)
            make.height.width.equalTo(24)
            make.centerY.equalTo(searchBar)
        }
    }
}

extension SearchFriendHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearchText(searchText)
    }
}

