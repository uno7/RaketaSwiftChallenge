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
    
    private enum CodingKeys: String, CodingKey {
        case author,
             created,
             title,
             thumbnail,
             preview,
             comments = "num_comments"
    }
}
