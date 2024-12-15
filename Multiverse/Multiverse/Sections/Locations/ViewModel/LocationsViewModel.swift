//
//  LocationsViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

protocol LocationViewModelDelegate: AnyObject {
    func didUpdateLocations(_ locations: [LocationDetail])
    func didFailWithError(_ error: Error)
}

protocol LocationCoordinatorDelegate: AnyObject {
    func navigateToLocationDetails(withID characterID: Int)
}

class LocationViewModel {
    weak var delegate: LocationViewModelDelegate?
    weak var coordinatorDelegate: LocationCoordinatorDelegate?
    private var service: MultiverseService
    var paginationManager = PaginationManager()
    var allLocations: [LocationDetail] = []
    
    init(service: MultiverseService) {
        self.service = service
    }
    
    func fetchLocations() {
        guard paginationManager.canFetchNextPage() else { return }
        
        paginationManager.isFetching = true
        service.fetchLocations(page: paginationManager.currentPage) { [weak self] result in
            guard let self = self else { return }
            self.paginationManager.isFetching = false
            
            switch result {
            case .success(let response):
                self.paginationManager.updatePagination(totalPages: response.info.pages ?? 1)
                self.allLocations.append(contentsOf: response.results)
                self.delegate?.didUpdateLocations(self.allLocations)
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func resetPagination() {
        paginationManager.resetPagination()
        allLocations = []
    }
    
    func selectLocation(at index: Int) {
        guard index < allLocations.count else { return }
        guard let characterId = allLocations[index].id else { return }
        coordinatorDelegate?.navigateToLocationDetails(withID: characterId)
    }
}
