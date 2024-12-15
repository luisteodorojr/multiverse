//
//  CharacterDetailViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

protocol CharacterDetailViewModelDelegate: AnyObject {
    func didFetchCharacterDetails()
    func didFailToFetchCharacterDetails(with error: Error)
}

protocol CharacterDetailCoordinatorDelegate: AnyObject {
    func didSelectEpisode(withID episodeID: Int)
}

final class CharacterDetailViewModel {
    weak var delegate: CharacterDetailViewModelDelegate?
    weak var coordinatorDelegate: CharacterDetailCoordinatorDelegate?
    private let service: MultiverseService
    var character: Character?
    let characterId: Int
    
    init(service: MultiverseService, characterId: Int) {
        self.service = service
        self.characterId = characterId
    }
    
    func fetchCharacterDetails() {
        service.fetchCharacterDetails(id: characterId) { [weak self] result in
            switch result {
            case .success(let character):
                self?.character = character
                self?.delegate?.didFetchCharacterDetails()
            case .failure(let error):
                self?.delegate?.didFailToFetchCharacterDetails(with: error)
            }
        }
    }
    
    func getEpisodeID(at index: Int) {
        guard let episodes = character?.episode, index >= 0, index < episodes.count else {
            return
        }
        
        let episodeURL = episodes[index]
        guard let id = Int(episodeURL.components(separatedBy: "/").last ?? "") else { return }
        selectEpisode(withID: id)
    }

    
    func selectEpisode(withID episodeID: Int) {
        coordinatorDelegate?.didSelectEpisode(withID: episodeID)
    }
}
