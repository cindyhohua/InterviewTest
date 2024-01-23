//
//  FriendViewModel.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/23.
//

import Combine
class FriendsViewModel: SearchFriendHeaderViewDelegate {
    private(set) var userData: [Response] = []
    private(set) var friendList: [Response] = []
    private(set) var requestList: [Response] = []
    @Published private(set) var filteredFriendList: [Response] = []
    private(set) var isExpanded: Bool = false

    func fetchUserData() {
        APIManager.shared.fetchUserData { [weak self] result in
            switch result {
            case .success(let userData):
                self?.userData = userData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchFriendData() {
        APIManager.shared.fetchFriendData { [weak self] result in
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
}
