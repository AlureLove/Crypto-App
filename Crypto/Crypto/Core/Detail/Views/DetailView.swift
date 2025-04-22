//
//  DetailView.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ChartView(coin: vm.coin)
                        .padding(.vertical)
                    
                    VStack(spacing: 20.0) {
                        overviewTitle
                        
                        Divider()
                        
                        descriptionSection
                        
                        overviewGrid
                        
                        additionalTitle
                        
                        Divider()
                        
                        additionalGrid
                        
                        websiteSection
                    }
                    .padding()
                }
            }
            .navigationTitle(vm.coin.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    navigationBarTrailingItems
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less..." : "  Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            if let website = vm.websiteURL,
               let url = URL(string: website) {
                Link("Website", destination: url)
            }
            
            if let reddit = vm.redditURL,
               let url = URL(string: reddit) {
                Link("Reddit", destination: url)
            }
        }
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
