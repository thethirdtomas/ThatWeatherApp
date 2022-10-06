//
//  RequestManager.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation
import Network

// MARK: - Errors
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case unableToComplete
}


// MARK: - Network Protocol
protocol Network {
    func send<T: Decodable>(_ request: Request) async -> Result<T, NetworkError>
}


// MARK: - RequestManager
final class RequestManager: Network {
    static let shared = RequestManager()
    private init() {}

    func send<T: Decodable>(_ request: Request) async -> Result<T, NetworkError> {
        
        guard let (data, response) = try? await URLSession.shared.data(for: request.urlRequest) else {
            return .failure(.unableToComplete)
        }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        guard (200..<300).contains(statusCode) else {
            return .failure(.invalidRequest)
        }
            
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(.invalidResponse)
        }
            
        return .success(result)
    }
}


// MARK: - Mock Network Object
struct MockNetwork: Network {
    func send<T: Decodable>(_ request: Request) async -> Result<T, NetworkError>  {
        return .failure(.unableToComplete)
    }
}

