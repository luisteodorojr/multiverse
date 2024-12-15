//
//  EpisodeDetailViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import Foundation

protocol EpisodeDetailViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
    func didFailToFetchEpisodeDetails(with error: Error)
    func didFetchEpisodeCharacters()
    func didFailToFetchEpisodeCharacters(with error: Error)
}

protocol EpisodeDetailCoordinatorDelegate: AnyObject {
    func didSelectCharacter(withId id: Int)
}

final class EpisodeDetailViewModel {
    private let service: MultiverseService
    let episodeID: Int
    weak var delegate: EpisodeDetailViewModelDelegate?
    weak var coordinatorDelegate: EpisodeDetailCoordinatorDelegate?
    
    var episodeDetail: Episode?
    var characters: [Character] = []
    
    init(service: MultiverseService, episodeID: Int) {
        self.service = service
        self.episodeID = episodeID
    }
    
    func fetchEpisodeDetails() {
        service.fetchEpisodeDetails(id: episodeID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let episode):
                self.episodeDetail = episode
                self.delegate?.didFetchEpisodeDetails()
                self.fetchEpisodeCharacters()
            case .failure(let error):
                self.delegate?.didFailToFetchEpisodeDetails(with: error)
            }
        }
    }
    
    func fetchEpisodeCharacters() {
        guard let characterURLs = episodeDetail?.characters else { return }
        let group = DispatchGroup()
        var fetchedCharacters: [Character] = []
        var fetchError: Error?
        
        for url in characterURLs {
            guard let characterID = Int(url.components(separatedBy: "/").last ?? "") else { continue }
            group.enter()
            service.fetchCharacterDetails(id: characterID) { result in
                switch result {
                case .success(let character):
                    fetchedCharacters.append(character)
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if let error = fetchError {
                self?.delegate?.didFailToFetchEpisodeCharacters(with: error)
            } else {
                self?.characters = fetchedCharacters
                self?.delegate?.didFetchEpisodeCharacters()
            }
        }
    }
    
    func selectCharacter(withId id: Int) {
        coordinatorDelegate?.didSelectCharacter(withId: id)
    }
}
