//
//  CharacterCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class CharacterCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController, parentCoordinator: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    func start() {
        
        let viewModel = CharacterViewModel(service: MultiverseService())
        viewModel.coordinatorDelegate = self
        let viewController = CharacterViewController(viewModel: viewModel)
        viewController.viewCoordinatorDelegate = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showCharacterDetails(characterId: Int) {
        let detailCoordinator = CharacterDetailCoordinator(navigationController: navigationController, characterId: characterId)
        detailCoordinator.parentCoordinator = self
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }

    func stop() {
        parentCoordinator?.removeChild(self)
    }
}

extension CharacterCoordinator: CharacterCoordinatorDelegate {
    func didSelectCharacter(withId id: Int) {
        showCharacterDetails(characterId: id)
    }
}

extension CharacterCoordinator: CoordinatorDelegate {
    func didFinish(from viewController: UIViewController) {
        stop()
    }
}
