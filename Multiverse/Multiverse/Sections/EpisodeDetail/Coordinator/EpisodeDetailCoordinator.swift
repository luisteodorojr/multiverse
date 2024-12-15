//
//  EpisodeDetailCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class EpisodeDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let episodeID: Int
    
    init(navigationController: UINavigationController, episodeID: Int, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.episodeID = episodeID
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = EpisodeDetailViewModel(service: MultiverseService(), episodeID: episodeID)
        viewModel.coordinatorDelegate = self
        let viewController = EpisodeDetailViewController(viewModel: viewModel)
        viewController.viewCoordinatorDelegate = self
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

extension EpisodeDetailCoordinator: EpisodeDetailCoordinatorDelegate {
    func didSelectCharacter(withId id: Int) {
        showCharacterDetails(characterId: id)
    }
}

extension EpisodeDetailCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}
