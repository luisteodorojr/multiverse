//
//  EpisodesViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

protocol EpisodesViewModelDelegate: AnyObject {
    func didUpdateEpisodes(_ episodes: [Episode])
    func didFailWithError(_ error: Error)
}

protocol EpisodesCoordinatorDelegate: AnyObject {
    func didSelectEpisode(withID episodeID: Int)
}

class EpisodesViewModel {
    private let service: MultiverseService
    var paginationManager = PaginationManager()
    var episodes: [Episode] = []
    weak var delegate: EpisodesViewModelDelegate?
    weak var coordinatorDelegate: EpisodesCoordinatorDelegate?
    
    init(service: MultiverseService) {
        self.service = service
    }
    
    func fetchEpisodes() {
        guard paginationManager.canFetchNextPage() else { return }
        
        paginationManager.isFetching = true
        service.fetchEpisodes(page: paginationManager.currentPage) { [weak self] result in
            guard let self = self else { return }
            self.paginationManager.isFetching = false
            
            switch result {
            case .success(let response):
                self.paginationManager.updatePagination(totalPages: response.info.pages ?? 1)
                self.episodes.append(contentsOf: response.results)
                self.delegate?.didUpdateEpisodes(self.episodes)
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func selectEpisode(at index: Int) {
        guard index < episodes.count else { return }
        guard let episodeID = episodes[index].id else { return }
        coordinatorDelegate?.didSelectEpisode(withID: episodeID)
    }
    
    func resetPagination() {
        paginationManager.resetPagination()
        episodes = []
    }
}
