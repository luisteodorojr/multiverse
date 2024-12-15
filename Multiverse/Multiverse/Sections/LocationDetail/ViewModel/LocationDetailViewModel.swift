//
//  LocationDetailViewModel.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import Foundation

protocol LocationDetailViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
    func didFailToFetchLocationDetails(with error: Error)
    func didFetchResidents()
    func didFailToFetchResidents(with error: Error)
}

protocol LocationDetailCoordinatorDelegate: AnyObject {
    func navigateToCharacterDetails(withID characterID: Int)
}

final class LocationDetailViewModel {
    private let service: MultiverseService
    let locationID: Int
    weak var delegate: LocationDetailViewModelDelegate?
    weak var coordinatorDelegate: LocationDetailCoordinatorDelegate?
    
    var locationDetail: LocationDetail?
    var residents: [Character] = []
    
    init(service: MultiverseService, locationID: Int) {
        self.service = service
        self.locationID = locationID
    }
    
    func fetchLocationDetails() {
        service.fetchLocationDetails(id: locationID) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.locationDetail = detail
                self?.delegate?.didFetchLocationDetails()
                self?.fetchResidents()
            case .failure(let error):
                self?.delegate?.didFailToFetchLocationDetails(with: error)
            }
        }
    }
    
    func fetchResidents() {
        guard let residentURLs = locationDetail?.residents else { return }
        
        let group = DispatchGroup()
        var fetchedResidents: [Character] = []
        var fetchError: Error?

        for url in residentURLs {
            guard let characterID = Int(url.components(separatedBy: "/").last ?? "") else { continue }
            group.enter()
            service.fetchCharacterDetails(id: characterID) { result in
                switch result {
                case .success(let character):
                    fetchedResidents.append(character)
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if let error = fetchError {
                self?.delegate?.didFailToFetchResidents(with: error)
            } else {
                self?.residents = fetchedResidents
                self?.delegate?.didFetchResidents()
            }
        }
    }
    
    func selectResident(withID id: Int) {
        coordinatorDelegate?.navigateToCharacterDetails(withID: id)
    }
}
