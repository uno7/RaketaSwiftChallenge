//
//  GetPostsRequest.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

class TopPostsRequest:Request{
    var urlRequest: URLRequest{
        let requestUrl =  self.nextID.count > 0 ? redditUrlString + "?after=\(nextID)" : redditUrlString
        return URLRequest(url: URL(string: requestUrl)!)
    }
    var nextID :String = ""
    init(nextID:String)  {
        self.nextID = nextID
    }
}
