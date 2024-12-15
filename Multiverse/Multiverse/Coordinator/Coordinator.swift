//
//  Coordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
    func stop()
    func removeChild(_ child: Coordinator)
}

extension Coordinator {
    func removeChild(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }

    func stop() {
        parentCoordinator?.removeChild(self)
    }
}
