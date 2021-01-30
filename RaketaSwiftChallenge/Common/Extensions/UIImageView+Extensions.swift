//
//  UIImageView+Extensions.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation
import UIKit

extension UIImageView{
    func loadImage (urlString:String?, successBlock:((Bool) ->Void)? = nil){
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = nil
            successBlock?(false)
            return
        }
                
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            DispatchQueue.main.async {
                successBlock?(true)
            }
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if (error != nil) {
                    self?.image = nil
                    successBlock?(false)
                }
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                    DispatchQueue.main.async {
                        successBlock?(true)
                    }
                }
            }
        }.resume()
    }
}
