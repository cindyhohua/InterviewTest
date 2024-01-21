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

enum APIError: Error {
    case invalidURL
    case noData
    case jsonParsingError(Error)
}

class APIManager {
    private init() {}
    
    static let shared = APIManager()
    
    let urlString = "https://dimanyen.github.io/"
    
    typealias FetchCompletion<T> = (Result<T, APIError>) -> Void
    
    var endPoint: APIEndpoint = .friend3
    
    func fetchFriendData(completion: @escaping FetchCompletion<APIResponse>) {
        guard let url = URL(string: urlString + endPoint.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        fetchData(from: url, completion: completion)
    }
    
    func fetchUserData(completion: @escaping FetchCompletion<APIResponse>) {
        guard let url = URL(string: urlString + APIEndpoint.userData.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        fetchData(from: url, completion: completion)
    }
    
    private func fetchData<T: Codable>(from url: URL, completion: @escaping FetchCompletion<T>) {
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
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let parseError {
                completion(.failure(.jsonParsingError(parseError)))
            }
        }
        task.resume()
    }
}
