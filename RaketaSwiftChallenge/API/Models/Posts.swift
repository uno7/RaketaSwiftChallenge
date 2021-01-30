//
//  Posts.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

struct Posts:Codable {
    let after:String?
    let children:[PostChildren]
}
