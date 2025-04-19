//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/19.
//

import Foundation

@Observable class HomeViewModel {
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
    
}
