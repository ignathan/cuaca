//
//  SceneDelegate.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        let rootVC = HomeViewController()
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

