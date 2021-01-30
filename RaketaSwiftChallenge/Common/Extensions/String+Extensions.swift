//
//  String+Extensions.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 30.01.2021.
//

import Foundation

extension String {
  var localizedString: String {
    return NSLocalizedString(self, comment: "")
  }
    var htmlToString: String {
      guard
        let data = data(using: .utf8),
        let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
      else {
        return self
      }
      return attributedString.string
    }
}
