//
//  CoinImageView.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/20.
//

import SwiftUI



struct CoinImageView: View {
    
    @State var vm: CoinImageViewModel
    
    init(coin: CoinModel) {
        _vm = State(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: dev.coin)
        .padding()
}
