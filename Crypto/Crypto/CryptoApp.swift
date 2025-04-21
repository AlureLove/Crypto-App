//
//  CryptoApp.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/19.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbarVisibility(.hidden)
            }
            .preferredColorScheme(.dark)
            .environmentObject(vm)
        }
    }
}
