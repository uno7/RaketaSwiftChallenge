//
//  MainCoordinator.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 01.02.2021.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start (){
        let vc = TopPostsViewController.instatiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func transitonToImageDetailsViewController(imageUrl:String) {
        let vc = ImageDetailsViewController.instatiate()
        vc.imageUrl = imageUrl
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
