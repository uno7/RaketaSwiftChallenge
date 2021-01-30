//
//  UITableView+Registration.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation
import UIKit

extension UITableView{
    func registerCell(reuseID:String, isXib:Bool) {
        if (isXib) {
            let nib = UINib(nibName: reuseID, bundle: nil)
            self.register(nib, forCellReuseIdentifier: reuseID)
            return
        }
        self.register(NSClassFromString(reuseID), forCellReuseIdentifier: reuseID)
    }
}
