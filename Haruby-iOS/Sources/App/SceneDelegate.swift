//
//  SceneDelegate.swift
//  Haruby-iOS
//
//  Created by namdghyun on 10/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        print("Scene Delegate - Will Connect")
        
        let reactor = MainReactor()
        let vc = MainViewController()
        vc.reactor = reactor
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
