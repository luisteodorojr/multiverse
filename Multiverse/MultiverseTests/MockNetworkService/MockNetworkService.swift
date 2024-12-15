//
//  MockNetworkService.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import XCTest
@testable import Multiverse

class MockNetworkService: NetworkServiceProtocol {
    var mockFileName: String?

    func request<T: Decodable>(_ api: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let mockFileNameToUse = mockFileName ?? api.endpoint.replacingOccurrences(of: "/", with: "_") + ".json"
        
        print("MockNetworkService: Requesting \(mockFileNameToUse)")
        
        guard let path = Bundle(for: type(of: self)).path(forResource: mockFileNameToUse, ofType: nil) else {
            print("MockNetworkService: File \(mockFileNameToUse) not found")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("MockNetworkService: Successfully decoded \(mockFileNameToUse)")
            completion(.success(decodedData))
        } catch {
            print("MockNetworkService: Failed to decode \(mockFileNameToUse) with error \(error)")
            completion(.failure(NetworkError.decodingError(error)))
        }
    }
}
