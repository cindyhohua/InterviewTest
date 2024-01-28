//
//  FriendsModel.swift
//  InterviewTest_Cindy
//
//  Created by 賀華 on 2024/1/20.
//

import Foundation

protocol APIManagerProtocol {
    func fetchUserData(completion: @escaping (Result<[Response], APIError>) -> Void)
    func fetchFriendData(completion: @escaping (Result<[Response], APIError>) -> Void)
    var condition: Condition { get set }
}

struct APIResponse: Codable {
    let response: [Response]
}

struct Response: Codable, Equatable {
    let name: String
    let isTop, fid, updateDate, kokoid: String?
    let status: Int?
    static func == (lhs: Response, rhs: Response) -> Bool {
        if let lhsKokoid = lhs.kokoid, let rhsKokoid = rhs.kokoid {
            return lhs.name == rhs.name && lhsKokoid == rhsKokoid
        } else {
            return lhs.name == rhs.name && lhs.isTop == rhs.isTop && lhs.fid == rhs.fid && lhs.status == rhs.status
        }
    }
}

enum APIEndpoint: String {
    case userData = "man.json"
    case friend1 = "friend1.json"
    case friend2 = "friend2.json"
    case friend3 = "friend3.json"
    case friend4 = "friend4.json"
}

enum Condition: String {
    case noData = "No data"
    case onlyFriendsData = "Only friends"
    case friendsDataAndRequest = "Friends and request"
}

enum APIError: Error {
    case invalidURL
    case noData
    case jsonParsingError(Error)
}

class APIManager: APIManagerProtocol {
    init() {}
    
    let baseURLString = "https://dimanyen.github.io/"
    
    typealias FetchCompletion = (Result<[Response], APIError>) -> Void
    
    var condition: Condition = .onlyFriendsData
    
    func fetchFriendData(completion: @escaping FetchCompletion) {
        switch condition {
        case .noData:
            fetchData(endpoint: .friend4, completion: completion)
        case .onlyFriendsData:
            fetchMultipleEndpoints(endpoints: [.friend1, .friend2], completion: completion)
        case .friendsDataAndRequest:
            fetchData(endpoint: .friend3, completion: completion)
        }
    }
    
    func fetchUserData(completion: @escaping FetchCompletion) {
        fetchData(endpoint: .userData, completion: completion)
    }
    
    private func fetchMultipleEndpoints(endpoints: [APIEndpoint], completion: @escaping FetchCompletion) {
        let group = DispatchGroup()
        var allData: [Response] = []
        
        for endpoint in endpoints {
            group.enter()
            fetchData(endpoint: endpoint) { result in
                switch result {
                case .success(let data):
                    allData += data
                case .failure(_):
                    break
                }
                group.leave()
            }
        }
        
        group.notify(queue: .global()) {
            let uniqueLatestData = self.getLatestRecords(from: allData)
            completion(.success(uniqueLatestData))
        }
    }
    
    private func fetchData(endpoint: APIEndpoint, completion: @escaping FetchCompletion) {
        guard let url = URL(string: baseURLString + endpoint.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(.jsonParsingError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(decodedData.response))
            } catch {
                completion(.failure(.jsonParsingError(error)))
            }
        }
        task.resume()
    }

    private func getLatestRecords(from data: [Response]) -> [Response] {
        var latestRecords: [String: Response] = [:]
        data.forEach { datum in
            guard let fid = datum.fid, let newUpdateDate = datum.updateDate?.filter({ $0.isNumber }) else { return }
            if let existingRecord = latestRecords[fid],
               let existingUpdateDate = existingRecord.updateDate?.filter({ $0.isNumber }),
               existingUpdateDate >= newUpdateDate {
                return
            }
            latestRecords[fid] = datum
        }
        
        return latestRecords.values.sorted(by: { (left, right) in
            guard let leftFid = left.fid, let rightFid = right.fid else {
                return left.fid != nil 
            }
            return leftFid < rightFid
        })
    }

}
