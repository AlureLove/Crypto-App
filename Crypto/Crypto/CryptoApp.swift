//
//  CryptoApp.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/19.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @State private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbarVisibility(.hidden)
            }
            .environment(vm)
        }
    }
}
