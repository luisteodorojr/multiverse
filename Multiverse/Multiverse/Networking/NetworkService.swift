//
//  NetworkService.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ api: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    static var shared: NetworkServiceProtocol = NetworkService()
    private init() {}
    
    func request<T: Decodable>(_ api: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: api.baseURL + api.endpoint) else {
            logDebug("Invalid URL: \(api.baseURL + api.endpoint)")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        
        switch api.task {
        case .requestPlain:
            break
        case .requestParameters(let parameters):
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                logDebug("Failed to encode parameters: \(parameters)")
                completion(.failure(NetworkError.invalidParameters))
                return
            }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsConstrainedNetworkAccess = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration)
        
        logRequest(urlRequest)
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                self.logDebug("Request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logDebug("Invalid response: \(String(describing: response))")
                completion(.failure(NetworkError.noData))
                return
            }
            
            self.logDebug("Response Status Code: \(httpResponse.statusCode)")
            self.logDebug("Response Headers: \(httpResponse.allHeaderFields)")
            
            guard let data = data else {
                self.logDebug("No data received")
                completion(.failure(NetworkError.noData))
                return
            }
            
            self.logDebug("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = "HTTP Error \(httpResponse.statusCode): \(String(data: data, encoding: .utf8) ?? "No error message")"
                self.logDebug(errorMessage)
                completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                self.logDebug("Decoded Data: \(decodedData)")
                completion(.success(decodedData))
            } catch {
                self.logDebug("Decoding failed with error: \(error)")
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    
    private func logRequest(_ request: URLRequest) {
#if DEBUG
        print("======== REQUEST ========")
        print("URL: \(request.url?.absoluteString ?? "No URL")")
        print("Method: \(request.httpMethod ?? "No Method")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Invalid UTF-8 data")")
        } else {
            print("Body: No body")
        }
        print("=========================")
#endif
    }
    
    private func logDebug(_ message: String) {
#if DEBUG
        print("DEBUG: \(message)")
#endif
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidParameters
    case decodingError(Error)
    case httpError(statusCode: Int, data: Data)
}
