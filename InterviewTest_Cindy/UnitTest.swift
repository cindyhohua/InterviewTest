//
//  UnitTest.swift
//  InterviewTest_CindyTests
//
//  Created by 賀華 on 2024/1/28.
//

import XCTest
@testable import InterviewTest_Cindy

final class UnitTest: XCTestCase {
    
    var viewModel: FriendsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FriendsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // 测试 fetchUserData 方法
    func testFetchUserData() {
        // 创建一个模拟的 APIManager
        let mockAPIManager = MockAPIManager()
        viewModel.apiManager = mockAPIManager
        
        // 创建一个模拟的用户数据
        let mockUserData = [Response(name: "User1"), Response(name: "User2")]
        mockAPIManager.mockUserData = .success(mockUserData)
        
        // 调用 fetchUserData 方法
        viewModel.fetchUserData()
        
        // 验证是否成功获取用户数据
        XCTAssertEqual(viewModel.userData, mockUserData)
    }
    
    func testFetchFriendData() {
           // 创建一个模拟的 APIManager
           let mockAPIManager = MockAPIManager()
           viewModel.apiManager = mockAPIManager

           // 创建模拟的朋友数据
           let mockFriendData = [Response(name: "Friend1", status: 1), Response(name: "Friend2", status: 0)]
           mockAPIManager.mockFriendData = .success(mockFriendData)

           // 调用 fetchFriendData 方法
           viewModel.fetchFriendData()

           // 验证是否成功获取朋友数据
           XCTAssertEqual(viewModel.friendList, mockFriendData.filter { $0.status == 1 })
           XCTAssertEqual(viewModel.requestList, mockFriendData.filter { $0.status == 0 })
       }
}

