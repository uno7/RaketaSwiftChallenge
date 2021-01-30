//
//  Preview.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

struct Preview : Codable{
    let images: [ImageResponse]
}

struct ImageResponse: Codable {
    let source: ImageSource
}

struct ImageSource: Codable {
    let url: String?
}
