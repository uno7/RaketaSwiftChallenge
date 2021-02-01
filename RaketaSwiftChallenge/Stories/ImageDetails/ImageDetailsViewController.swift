//
//  ImageDetailsViewController.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import UIKit
import Photos

class ImageDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var imageUrl:String?
    weak var coordinator:MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        setActivityIndicator()
        setUi()
        imageView.loadImage(urlString: imageUrl) {[weak self] (isFinished) in
            guard let strongSelf = self else {return}
            strongSelf.activityIndicatorView.stopExecutionOnAMainThread()
            strongSelf.imageDownloadFinished?(isFinished)
        }
    }
    
    //MARK:- private properties
    
    private var viewModel:ImageDetailsViewModel!
    private var imageDownloadFinished:((Bool)->())?
    
    
    //MARK:- private methods
   private func setActivityIndicator(){
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
    }
    
    private func setViewModel(){
        viewModel = ImageDetailsViewModel(delegate: self)
    }
    
    private func setUi (){
        navigationItem.title = "Image Details"
        imageDownloadFinished = { [weak self] (isFinished) in
            guard let strongSelf = self else {return}
            if !isFinished {
                let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
                strongSelf.showAlert(title: "Error".localizedString
                                     , message: "Something went wrong".localizedString,
                                     actions:[okAction])
                    return
                }
                let saveButton = UIBarButtonItem(title: "Save",
                                                 style: .plain,
                                                 target: strongSelf,
                                                 action: #selector(strongSelf.saveImage))
                strongSelf.navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @objc func saveImage(){
        getPermissionIfNecessary {[weak self] (isPermission) in
            guard let strongSelf = self else{return}
                if !isPermission{
                    let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
                    strongSelf.showAlert(title: "Error".localizedString,
                                         message: "You dont have permissions to save photo into photolibrary. You can change it in app settings".localizedString,
                                         actions:[okAction])
                    return
                }
            DispatchQueue.main.async {
                strongSelf.viewModel.saveImageToPhotoLibrary(image: strongSelf.imageView.image!)
            }
                
        }
    }
    
    private func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
}

extension ImageDetailsViewController : ImageDetailsViewModelDelegate{
    func imageSavingResult(didFinishSavingWithError error: Error?) {
        let message = error == nil ? "Image have been saved successfully".localizedString : "Unable to save photo".localizedString
        let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
        showAlert(title: "Message".localizedString,
                  message: message,
                  actions:[okAction])
        navigationItem.rightBarButtonItem?.isEnabled = error == nil ? false : true
    }
}
