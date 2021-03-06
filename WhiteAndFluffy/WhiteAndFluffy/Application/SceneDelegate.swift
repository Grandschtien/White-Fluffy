//
//  SceneDelegate.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: CoordinatorProtocol?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        window.overrideUserInterfaceStyle = .light
        coordinator = Coordinator(window: window)
        coordinator?.start()
    }
}

