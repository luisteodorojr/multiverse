//
//  MultiverseService.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

final class MultiverseService {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        networkService.request(MultiverseAPI.characters(page: page), completion: completion)
    }
    
    func fetchLocations(page: Int, completion: @escaping (Result<LocationResponse, Error>) -> Void) {
        networkService.request(MultiverseAPI.locations(page: page), completion: completion)
    }
    
    func fetchEpisodes(page: Int, completion: @escaping (Result<EpisodeResponse, Error>) -> Void) {
        networkService.request(MultiverseAPI.episodes(page: page), completion: completion)
    }
    
    func fetchCharacterDetails(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        networkService.request(MultiverseAPI.characterDetail(id: id), completion: completion)
    }
    
    func fetchEpisodeDetails(id: Int, completion: @escaping (Result<Episode, Error>) -> Void) {
        networkService.request(MultiverseAPI.episodeDetail(id: id), completion: completion)
    }
    
    func fetchLocationDetails(id: Int, completion: @escaping (Result<LocationDetail, Error>) -> Void) {
        let endpoint = MultiverseAPI.locationDetail(id: id)
        networkService.request(endpoint, completion: completion)
    }
}
