//
//  Service.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation
import Network


protocol Request {
    var urlRequest:URLRequest{get}
}

protocol Service{
    func  getTopPosts(request:Request, completionBlock:@escaping(Result<GetPostsResponse,ResponseError>) -> Void)
    func cancelNetworkRequest()
}

final class NetworkService : Service{
    private let monitor = NWPathMonitor()
    private var isAvailableInternet = true
    var dataTask:URLSessionDataTask?
    
    init() {
        setNetworkMonitor()
    }
    
    private func setNetworkMonitor() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            guard let strongSelf = self  else {
                return
            }
            strongSelf.isAvailableInternet = path.status == .satisfied
            strongSelf.monitor.start(queue: queue)
        }
    }
    
    func getTopPosts(request:Request, completionBlock: @escaping(Result<GetPostsResponse, ResponseError>) -> Void) {
        if !self.isAvailableInternet {
            completionBlock(.failure(ResponseError.noInternetConnectionError))
        }
        
        dataTask = URLSession.shared.dataTask(with: request.urlRequest) { (data, response, error) in
            if error != nil {completionBlock(.failure(ResponseError.networkError))}
            guard let data = data else {completionBlock(.failure(ResponseError.noDataError))
                return}
            do {
                let result = try JSONDecoder().decode(GetPostsResponse.self, from: data)
                completionBlock(.success(result))
            } catch {
                completionBlock(.failure(ResponseError.decodingError))
            }
        }
        dataTask?.resume()
    }
    
    func cancelNetworkRequest(){
        dataTask?.cancel()
    }
}
