//
//  SceneDelegate.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 27.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var coordinator:MainCoordinator?
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController ()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        
        coordinator = MainCoordinator.init(navigationController: navigationController)
        coordinator?.start()
        
        checkRestorationWithScene(scene, willConnectTo: session)
        
        window?.makeKeyAndVisible()
    }
    
    private func checkRestorationWithScene(_ scene: UIScene,willConnectTo session: UISceneSession){
        scene.userActivity = session.stateRestorationActivity ?? NSUserActivity(activityType: "restoration")
        if let navVC = window?.rootViewController as? UINavigationController,
           let rootVC = navVC.viewControllers.first as? TopPostsViewController {
            rootVC.restorationInfo = scene.userActivity?.userInfo
        }
        
    }
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}

