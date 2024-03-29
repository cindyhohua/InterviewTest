//
//  FriendViewModel.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/23.
//

import Combine
import UIKit
import Foundation

class FriendsViewModel: SearchFriendHeaderViewDelegate {
    @Published private(set) var filteredFriendList: [Response] = []
    private(set) var userData: [Response] = []
    private(set) var friendList: [Response] = []
    private(set) var requestList: [Response] = []
    private(set) var isExpanded: Bool = false
    @Published private(set) var searchBarIsToggled: Bool = false
    
    private var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
        NotificationCenter.default.addObserver(self, selector: #selector(handleConditionChange), name: .apiManagerConditionDidChange, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .apiManagerConditionDidChange, object: nil)
    }
    
    
    func fetchUserData() {
        apiManager.fetchUserData { [weak self] result in
            switch result {
            case .success(let userData):
                print("qq", userData)
                self?.userData = userData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchFriendData() {
        apiManager.fetchFriendData { [weak self] result in
            switch result {
            case .success(let friendData):
                self?.friendList.removeAll()
                self?.requestList.removeAll()
                friendData.forEach { data in
                    if data.status == 0 {
                        self?.requestList.append(data)
                    } else {
                        self?.friendList.append(data)
                    }
                }
                self?.isExpanded = false
                self?.filteredFriendList = self?.friendList ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleConditionChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let newCondition = userInfo["newCondition"] as? Condition {
            apiManager.condition = newCondition
            fetchFriendData()
        }
    }
    
    func changeExpended() {
        isExpanded = !isExpanded
    }

    func didChangeSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredFriendList = friendList
        } else {
            filteredFriendList = friendList.filter { $0.name.contains(searchText) }
        }
    }
    
    func didEndedSearchText() {
        searchBarIsToggled = false
    }
    
    func didBeginSearchText() {
        searchBarIsToggled = true
    }
}
