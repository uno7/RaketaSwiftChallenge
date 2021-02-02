//
//  ImageDetailsViewController.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import UIKit
import Photos

class ImageDetailsViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var imageUrl:String?
    weak var coordinator: MainCoordinator?
    
    //MARK:-restoration app properties
    var restorationInfo: [AnyHashable: Any]?
    static let restorationKey = "editing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        startActivityIndicator()
        setUi()
        imageView.loadImage(urlString: imageUrl) {[weak self] (isFinished) in
            guard let strongSelf = self else {return}
            strongSelf.activityIndicatorView.stopExecutionOnAMainThread()
            strongSelf.imageDownloadFinished?(isFinished)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userActivity = self.view.window?.windowScene?.userActivity
        self.restorationInfo = nil
    }
    
    //MARK:- private properties
    
    private var viewModel:ImageDetailsViewModel!
    private var imageDownloadFinished:((Bool)->())?
    
    
    //MARK:- private methods
   private func startActivityIndicator(){
        self.contentView.alpha = 0.3
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicator(){
        UIView.animate(withDuration: 0.3) {
            self.activityIndicatorView.isHidden = true
            self.contentView.alpha = 0
        }
        activityIndicatorView.stopExecutionOnAMainThread()
    }
    
    private func setViewModel(){
        viewModel = ImageDetailsViewModel(delegate: self)
    }
    
    private func setUi (){
        navigationItem.title = "Image Details"
        imageDownloadFinished = { [weak self] (isFinished) in
            guard let strongSelf = self else {return}
            strongSelf.stopActivityIndicator()
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
            DispatchQueue.main.async {
                if !isPermission{
                    let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
                    strongSelf.showAlert(title: "Permission Denied".localizedString,
                                         message: "You can enable Photo Library permission from the settings app".localizedString,
                                         actions:[okAction])
                    return
                }
                strongSelf.startActivityIndicator()
                strongSelf.viewModel.saveImageToPhotoLibrary(image: strongSelf.imageView.image!)
            }
            
        }
    }
    
    private func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }
    
    //MARK:- user activity
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        let key = Self.restorationKey
        let info :[AnyHashable:Any] = [key:true,"imageUrl": imageUrl as Any]
        activity.addUserInfoEntries(from:info )
    }
}

extension ImageDetailsViewController : ImageDetailsViewModelDelegate{
    func imageSavingResult(didFinishSavingWithError error: Error?) {
        let message = error == nil ? "Image have been saved successfully".localizedString : "Unable to save photo".localizedString
        let okAction = UIAlertAction(title: "OK".localizedString, style: .default)
        showAlert(title: "Success".localizedString,
                  message: message,
                  actions:[okAction])
        navigationItem.rightBarButtonItem?.isEnabled = error == nil ? false : true
        stopActivityIndicator()
    }
}
