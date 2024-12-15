//
//  EpisodesCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class EpisodesCoordinator: Coordinator, EpisodesCoordinatorDelegate {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = EpisodesViewModel(service: MultiverseService())
        viewModel.coordinatorDelegate = self
        let viewController = EpisodesViewController(viewModel: viewModel)
        viewController.viewCoordinatorDelegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func stop() {
        parentCoordinator?.removeChild(self)
    }
    
    func didSelectEpisode(withID episodeID: Int) {
        let detailCoordinator = EpisodeDetailCoordinator(navigationController: navigationController, episodeID: episodeID, parentCoordinator: self)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}

extension EpisodesCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}
