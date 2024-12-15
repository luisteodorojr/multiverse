//
//  CharacterDetailCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

final class CharacterDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let characterId: Int

    init(navigationController: UINavigationController, characterId: Int) {
        self.navigationController = navigationController
        self.characterId = characterId
    }

    func start() {
        let service = MultiverseService()
        let viewModel = CharacterDetailViewModel(service: service, characterId: characterId)
        viewModel.coordinatorDelegate = self
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        detailVC.viewCoordinatorDelegate = self
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}

extension CharacterDetailCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}

extension CharacterDetailCoordinator: CharacterDetailCoordinatorDelegate {
    func didSelectEpisode(withID episodeID: Int) {
        let detailCoordinator = EpisodeDetailCoordinator(navigationController: navigationController, episodeID: episodeID, parentCoordinator: self)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }
}
