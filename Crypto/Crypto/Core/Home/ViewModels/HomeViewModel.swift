//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/19.
//

import Foundation
import Combine

@Observable class HomeViewModel {
    var allCoins: [CoinModel] = []
    var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
 
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
