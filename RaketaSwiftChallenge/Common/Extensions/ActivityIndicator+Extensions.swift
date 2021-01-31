//
//  ActivityIndicator+Extensions.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import Foundation
import UIKit

extension UIActivityIndicatorView{
    func stopExecutionOnAMainThread (){
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}

