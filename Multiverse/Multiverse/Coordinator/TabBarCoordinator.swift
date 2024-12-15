//
//  TabBarCoordinator.swift
//  Multiverse
//
//  Created by Luis Teodoro on 13/12/24.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private var tabBarController: UITabBarController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        setupTabBarAppearance()
    }

    func start() {
        let characterNavigationController = UINavigationController()
        let characterCoordinator = CharacterCoordinator(navigationController: characterNavigationController, parentCoordinator: self)
        childCoordinators.append(characterCoordinator)
        characterCoordinator.start()
        characterNavigationController.tabBarItem = UITabBarItem(
            title: "Personagens",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        let locationNavigationController = UINavigationController()
        let locationsCoordinator = LocationsCoordinator(navigationController: locationNavigationController, parentCoordinator: self)
        childCoordinators.append(locationsCoordinator)
        locationsCoordinator.start()
        locationNavigationController.tabBarItem = UITabBarItem(
            title: "Localizações",
            image: UIImage(systemName: "mappin.and.ellipse"),
            selectedImage: UIImage(systemName: "mappin.and.ellipse.fill")
        )
        
        let episodesNavigationController = UINavigationController()
        let episodesCoordinator = EpisodesCoordinator(navigationController: episodesNavigationController, parentCoordinator: self)
        childCoordinators.append(episodesCoordinator)
        episodesCoordinator.start()
        episodesNavigationController.tabBarItem = UITabBarItem(
            title: "Episódios",
            image: UIImage(systemName: "film"),
            selectedImage: UIImage(systemName: "film.fill")
        )

        tabBarController.viewControllers = [
            characterNavigationController,
            locationNavigationController,
            episodesNavigationController
        ]

        navigationController.viewControllers = [tabBarController]
    }

    func stop() {
        parentCoordinator?.removeChild(self)
    }

    func removeChild(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }

    private func setupTabBarAppearance() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.25, green: 0.75, blue: 0.85, alpha: 1.0).cgColor,
            UIColor(red: 0.67, green: 0.87, blue: 0.31, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49)

        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = gradientImage

        let selectedColor = UIColor.white
        let normalColor = UIColor.lightGray

        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = normalColor
    }
}
