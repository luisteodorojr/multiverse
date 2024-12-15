//
//  CharacterViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

// CharacterViewModel.swift
protocol CharacterViewModelDelegate: AnyObject {
    func didUpdateCharacters(_ characters: [Character])
    func didFailWithError(_ error: Error)
}

protocol CharacterCoordinatorDelegate: AnyObject {
    func didSelectCharacter(withId id: Int)
}

class CharacterViewModel {
    weak var delegate: CharacterViewModelDelegate?
    weak var coordinatorDelegate: CharacterCoordinatorDelegate?
    private var service: MultiverseService?
    var paginationManager = PaginationManager()
    var allCharacters: [Character] = []
    
    init(service: MultiverseService) {
        self.service = service
    }
    
    func fetchCharacters() {
        guard paginationManager.canFetchNextPage() else { return }
        
        paginationManager.isFetching = true
        service?.fetchCharacters(page: paginationManager.currentPage) { [weak self] result in
            guard let self = self else { return }
            self.paginationManager.isFetching = false
            
            switch result {
            case .success(let response):
                self.paginationManager.updatePagination(totalPages: response.info?.pages ?? 1)
                self.allCharacters.append(contentsOf: response.results ?? [])
                self.delegate?.didUpdateCharacters(self.allCharacters)
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func selectCharacter(at index: Int) {
        guard index < allCharacters.count else { return }
        guard let characterId = allCharacters[index].id else { return }
        coordinatorDelegate?.didSelectCharacter(withId: characterId)
    }
    
    func resetPagination() {
        paginationManager.resetPagination()
        allCharacters = []
    }
}
