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
    var mockViewModel: FriendsViewModel!
    override func setUp() {
        super.setUp()
        viewModel = FriendsViewModel(apiManager: APIManager())
        mockViewModel = FriendsViewModel(apiManager: MockAPIManager())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchUserData() {
        viewModel.fetchUserData()
        mockViewModel.fetchUserData()
        sleep(5)
        print("viewModel",viewModel.userData)
        print("mock",mockViewModel.userData)
        XCTAssertEqual(viewModel.userData, mockViewModel.userData)
    }
}
