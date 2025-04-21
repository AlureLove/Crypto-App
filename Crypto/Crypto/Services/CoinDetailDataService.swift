//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": SecretKeyManager.api_key
        ]
        
        let queryItems = [
          URLQueryItem(name: "localization", value: "false"),
          URLQueryItem(name: "tickers", value: "false"),
          URLQueryItem(name: "market_data", value: "false"),
          URLQueryItem(name: "community_data", value: "false"),
          URLQueryItem(name: "developer_data", value: "false"),
          URLQueryItem(name: "sparkline", value: "false"),
        ]
        
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = queryItems
            if let urlWithQuery = components.url {
                request.url = urlWithQuery
            }
        }
        
        coinDetailSubscription =
        NetworkingManager.download(url: request)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
