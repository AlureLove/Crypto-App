//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] returnedDetails in
                self?.coinDescription = returnedDetails?.description?.en
                self?.websiteURL = returnedDetails?.links?.homepage?.first
                self?.redditURL = returnedDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        // overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(
            title: "Current Price",
            value: price,
            percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(
            title: "Market Capitalization",
            value: marketCap,
            percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(
            title: "Rank",
            value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(
            title: "Volume",
            value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        // additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highSet = StatisticModel(
            title: "24H High",
            value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowSet = StatisticModel(
            title: "24H Low",
            value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(
            title: "24H Price Change",
            value: priceChange,
            percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(
            title: "24H Market Cap Change",
            value: marketCapChange,
            percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockTimeStat = StatisticModel(
            title: "Block Time",
            value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(
            title: "Hashing Algorithm",
            value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highSet,
            lowSet,
            priceChangeStat,
            marketCapChangeStat,
            blockTimeStat,
            hashingStat
        ]
        
        return additionalArray
    }
}
