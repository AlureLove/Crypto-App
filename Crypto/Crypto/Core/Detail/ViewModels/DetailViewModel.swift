//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                print("received new data: \(returnedCoinDetails)")
            }
            .store(in: &cancellables)
    }
}
