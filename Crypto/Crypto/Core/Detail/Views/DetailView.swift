//
//  DetailView.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import SwiftUI

struct DetailView: View {
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        ZStack {
            Text(coin.name)
        }
    }
}

#Preview {
    DetailView(coin: dev.coin)
}
