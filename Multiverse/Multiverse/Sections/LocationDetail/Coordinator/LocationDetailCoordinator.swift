//
//  LocationDetailCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class LocationDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let locationID: Int
    
    init(navigationController: UINavigationController, locationID: Int, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.locationID = locationID
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = LocationDetailViewModel(service: MultiverseService(), locationID: locationID)
        viewModel.coordinatorDelegate = self
        let viewController = LocationDetailViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func stop() {
        parentCoordinator?.removeChild(self)
    }
    
    func showCharacterDetails(characterId: Int) {
        let detailCoordinator = CharacterDetailCoordinator(navigationController: navigationController, characterId: characterId)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}

extension LocationDetailCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}

extension LocationDetailCoordinator: LocationDetailCoordinatorDelegate {
    func navigateToCharacterDetails(withID characterID: Int) {
        showCharacterDetails(characterId: characterID)
    }
}
