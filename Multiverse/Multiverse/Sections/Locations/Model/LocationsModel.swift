//
//  LocationsModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

struct LocationResponse: Decodable {
    let info: Info
    let results: [LocationDetail]
}

struct LocationDetail: Decodable {
    let id: Int?
    let name: String?
    let type: String?
    let url: String?
    let dimension: String?
    let residents: [String]?
}
