//
//  MockAPIMannager.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/28.
//

import Foundation
class MockAPIManager: APIManagerProtocol {
    var condition: Condition = .onlyFriendsData
    
    
    var mockUserDataResult: Result<[Response], APIError>?
    var mockFriendDataResult: Result<[Response], APIError>?
    
    func fetchUserData(completion: @escaping (Result<[Response], APIError>) -> Void) {
        if let result = mockUserDataResult {
            completion(result)
        }
    }
    
    func fetchFriendData(completion: @escaping (Result<[Response], APIError>) -> Void) {
        if let result = mockFriendDataResult {
            completion(result)
        }
    }
}
