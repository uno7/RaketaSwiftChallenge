//
//  Storyboarded.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 01.02.2021.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instatiate () ->Self
}

extension Storyboarded where Self:UIViewController{
    
    static func instatiate () ->Self{
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }

}
