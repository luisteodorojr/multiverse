//
//  MultiverseAPI.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

enum MultiverseAPI {
    case characters(page: Int)
    case locations(page: Int)
    case episodes(page: Int)
    case characterDetail(id: Int)
    case episodeDetail(id: Int)
    case locationDetail(id: Int)
}

extension MultiverseAPI: NetworkRequest {
    var baseURL: String { "https://rickandmortyapi.com/api/" }
    
    var method: HTTPMethod { .get }
    
    var endpoint: String {
        switch self {
        case .characters(let page):
            return "character?page=\(page)"
        case .locations(let page):
            return "location?page=\(page)"
        case .episodes(let page):
            return "episode?page=\(page)"
        case .characterDetail(let id):
            return "character/\(id)"
        case .episodeDetail(let id):
            return "episode/\(id)"
        case .locationDetail(let id):
               return "location/\(id)"
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var task: TaskType {
        return .requestPlain
    }
}
