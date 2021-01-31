//
//  ImageDetailsViewModel.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import Foundation
import UIKit

protocol ImageDetailsViewModelDelegate : class {
    func imageSavingResult(didFinishSavingWithError error:Error?)
}

final class ImageDetailsViewModel:NSObject {
    
    private weak var delegate: ImageDetailsViewModelDelegate?
    
    init(delegate:ImageDetailsViewModelDelegate) {
        self.delegate = delegate

    }
    
    //MARK:- Save photo to library
    func saveImageToPhotoLibrary(image: UIImage){
        DispatchQueue.global(qos: .userInitiated).async {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(self.image),
                                           nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        delegate?.imageSavingResult(didFinishSavingWithError: error)
    }
    
}
