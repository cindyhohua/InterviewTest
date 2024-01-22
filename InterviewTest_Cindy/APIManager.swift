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

enum APIEndpoint: String {
    case userData = "man.json"
    case friend1 = "friend1.json"
    case friend2 = "friend2.json"
    case friend3 = "friend3.json"
    case friend4 = "friend4.json"
}

enum Condition {
    case noData
    case onlyFriendsData
    case friendsDataAndRequest
}

enum APIError: Error {
    case invalidURL
    case noData
    case jsonParsingError(Error)
}

class APIManager {
    private init() {}
    
    static let shared = APIManager()
    
    let urlString = "https://dimanyen.github.io/"
    
    typealias FetchCompletion = (Result<[Response], APIError>) -> Void
    
    var condition: Condition = .noData
    
    func fetchFriendData(completion: @escaping FetchCompletion) {
        let endpoints: [APIEndpoint]
        
        switch condition {
        case .noData:
            endpoints = [.friend4]
        case .onlyFriendsData:
            endpoints = [.friend1, .friend2]
        case .friendsDataAndRequest:
            endpoints = [.friend3]
        }
        
        let dispatchGroup = DispatchGroup()
        var data: [Response] = []
        
        for endpoint in endpoints {
            guard let url = URL(string: urlString + endpoint.rawValue) else {
                completion(.failure(.invalidURL))
                return
            }
            
            dispatchGroup.enter()
            fetchData(from: url) { result in
                switch result {
                case .success(let response):
                    data += response
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            var latestRecords: [String: Response] = [:]
            for datum in data {
                if let existingRecord = latestRecords[datum.fid ?? ""] {
                    let existingUpdateDate = String(
                        existingRecord.updateDate?.filter { $0.isNumber } ?? "")
                    let newUpdateDate = String(
                        datum.updateDate?.filter { $0.isNumber } ?? "")
                    if existingUpdateDate < newUpdateDate {
                        latestRecords[datum.fid ?? ""] = datum
                    }
                } else {
                    latestRecords[datum.fid ?? ""] = datum
                }
            }
            let latestRecordsArray = Array(latestRecords.values)
            completion(.success(latestRecordsArray))
        }
    }
    
    func fetchUserData(completion: @escaping FetchCompletion) {
        guard let url = URL(string: urlString + APIEndpoint.userData.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        fetchData(from: url, completion: completion)
    }
    
    private func fetchData(from url: URL, completion: @escaping FetchCompletion) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.jsonParsingError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(APIResponse.self, from: data)
                completion(.success(decodedData.response))
            } catch let parseError {
                completion(.failure(.jsonParsingError(parseError)))
            }
        }
        task.resume()
    }
}
