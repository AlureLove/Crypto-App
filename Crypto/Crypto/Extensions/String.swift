//
//  String.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
