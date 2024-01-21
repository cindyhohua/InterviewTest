//
//  InterviewTest_CindyTests.swift
//  InterviewTest_CindyTests
//
//  Created by 賀華 on 2024/1/20.
//

import XCTest
@testable import InterviewTest_Cindy

class InterviewTest_CindyTests: XCTestCase {
    func testGetUserData() {
        APIManager.shared.fetchUserData { userData in

        }
    }

}
