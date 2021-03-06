//
//  PostChildrenEntity.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

struct PostChildrenEntity:Codable {
   
    let author: String
    let created: Int
    let comments: Int
    let title: String
    let thumbnail: String
    let preview: Preview?
    let name:String
    
    private enum CodingKeys: String, CodingKey {
        case author,
             created,
             title,
             thumbnail,
             preview,
             name,
             comments = "num_comments"
    }
    
    var timeAgo:String{
        let date = Date(timeIntervalSince1970: TimeInterval(created))
        return date.getElapsedInterval()
    }
    
    var imageUrl:String?{
        preview?.images.first?.source.url?.htmlToString
    }
}
