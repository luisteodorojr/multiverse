//
//  LocationsCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class LocationsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = LocationViewModel(service: MultiverseService())
        viewModel.coordinatorDelegate = self
        let viewController = LocationViewController(viewModel: viewModel)
        viewController.viewCoordinatorDelegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func stop() {
        parentCoordinator?.removeChild(self)
    }
    
    func didSelectEpisode(withID episodeID: Int) {
        let detailCoordinator = LocationDetailCoordinator(navigationController: navigationController, locationID: episodeID, parentCoordinator: self)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}

extension LocationsCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}

extension LocationsCoordinator: LocationCoordinatorDelegate {
    func navigateToLocationDetails(withID characterID: Int) {
        didSelectEpisode(withID: characterID)
    }
}
