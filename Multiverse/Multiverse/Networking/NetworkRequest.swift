//
//  NetworkRequest.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

protocol NetworkRequest: Path, Headers, Task {
    var baseURL: String { get }
    var method: HTTPMethod { get }
}

protocol Task {
    var task: TaskType { get }
}

enum TaskType {
    case requestPlain
    case requestParameters([String: Any])
}

protocol Headers {
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Path {
    var endpoint: String { get }
}
