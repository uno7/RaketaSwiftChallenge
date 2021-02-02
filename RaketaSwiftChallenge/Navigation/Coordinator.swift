//
//  Coordinator.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 01.02.2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {set get}
    func start ()
}
