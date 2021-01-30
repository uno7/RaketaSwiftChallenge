//
//  ErrorResponse.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

enum ResponseError: Error {
  
    case networkError
    case decodingError
    case noDataError
    case noInternetConnection
    
    var reason: String {
        switch self {
        case .networkError:
            return "An error occurred while fetching data ".localizedString
        case .decodingError:
            return "An error occurred while decoding data".localizedString
        case .noDataError:
            return "Ooops it seems there no data".localizedString
        case .noInternetConnection:
            return "Please check your internet conection and try again".localizedString
        }
    }
}
