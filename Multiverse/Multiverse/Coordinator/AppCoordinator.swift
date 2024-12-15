//
//  AppCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }

    func removeChild(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}
