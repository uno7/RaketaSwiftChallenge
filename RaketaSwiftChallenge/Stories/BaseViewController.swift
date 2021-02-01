//
//  BaseViewController.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import UIKit

class BaseViewController: UIViewController,Storyboarded {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }
    
}

//MARK:- Messages

extension BaseViewController {
    
    func showAlert (title:String,
                    message:String,
                    actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
