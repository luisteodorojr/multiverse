//
//  CharacterModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

struct CharacterResponse: Decodable {
    let info: Info?
    let results: [Character]?
}

struct Info: Decodable {
    let count: Int?
    let pages: Int?
    let next: String?
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: LocationDetail?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct Origin: Decodable {
    let name: String?
    let url: String?
}
