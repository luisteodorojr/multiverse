//
//  EpisodeModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

struct EpisodeResponse: Decodable {
    let info: Info
    let results: [Episode]
}

struct Episode: Codable {
    let id: Int?
    let name: String?
    let airDate: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
