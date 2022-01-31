//
//  Coordinator.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//

import Foundation

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start()
}

final class Coordinator: CoordinatorProtocol {
    private let window: UIWindow
    private lazy var tabBarController = UITabBarController()
    private lazy var navigationControllers = Coordinator.makeNavigationControllers()
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setupPhotos()
        setupFavorites()
        
        let navigationControllers = NavControllerType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        tabBarController.setViewControllers(navigationControllers, animated: true)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension Coordinator {
    
    private func setupPhotos() {
        guard let navController = navigationControllers[.photos] else {
            fatalError("No navController")
        }
        let photosContext = PhotosContext(moduleOutput: nil)
        let photosContainer = PhotosContainer.assemble(with: photosContext)
        navController.setViewControllers([photosContainer.viewController], animated: true)
    }
    
    private func setupFavorites() {
        guard let navController = navigationControllers[.favorites] else {
            fatalError("No navController")
        }
        let favoritesContext = FavoritesContext(moduleOutput: nil)
        let favoritesContainer = FavoritesContainer.assemble(with: favoritesContext)
        navController.setViewControllers([favoritesContainer.viewController], animated: true)
    }
    
    fileprivate static func makeNavigationControllers() -> [NavControllerType: UINavigationController] {
        var result: [NavControllerType: UINavigationController] = [:]
        NavControllerType.allCases.forEach { navControllerKey in
            let navigationController = UINavigationController()
            let tabBarItem = UITabBarItem(title: navControllerKey.title,
                                          image: navControllerKey.image,
                                          tag: navControllerKey.rawValue)
            navigationController.tabBarItem = tabBarItem
            result[navControllerKey] = navigationController
        }
        return result
    }
}

fileprivate enum NavControllerType: Int, CaseIterable {
    case photos, favorites
    
    var title: String {
        switch self {
        case .photos:
            return "Фото"
        case .favorites:
            return "Избранное"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .photos:
            return UIImage(named: "photos")
        case .favorites:
            return UIImage(named: "favorites")
        }
    }
}
