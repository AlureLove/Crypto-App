//
//  DetailView.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            Text("hello")
        }
    }
}

#Preview {
    DetailView(coin: dev.coin)
}
