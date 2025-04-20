//
//  UIApplication.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/20.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
