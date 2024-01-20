//
//  FriendsModel.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import Foundation

struct APIResponse: Codable {
    let response: [Response]
}

struct Response: Codable {
    let name: String
    let isTop, fid, updateDate, kokoid: String?
    let status: Int?
}

