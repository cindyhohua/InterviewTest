//
//  FriendViewModel.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/23.
//

class FriendsViewModel: SearchFriendHeaderViewDelegate {
    private var userData: [Response] = []
    private var friendList: [Response] = []
    private var requestList: [Response] = []
    private var filteredFriendList: [Response] = []
    private var isExpanded: Bool = false

    var reloadDataHandler: (() -> Void)?

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
                self?.reloadDataHandler?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserData() -> [Response] {
        return userData
    }
    
    func getRequestList() -> [Response] {
        return requestList
    }
    
    func getFriendList() -> [Response] {
        return friendList
    }
    
    func getFilteredFriendList() -> [Response] {
        return filteredFriendList
    }
    
    func getIsExpended() -> Bool {
        return isExpanded
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
        self.reloadDataHandler?()
    }
}
