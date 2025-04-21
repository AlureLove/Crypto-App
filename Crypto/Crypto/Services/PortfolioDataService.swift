//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Jethro Liu on 2025/04/21.
//

import Foundation
import CoreData

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading Core data: \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: Public
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        // check if coin is already in portfolio
        if let existingEntity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: existingEntity, amount: amount)
            } else {
                delete(entity: existingEntity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: Private
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entity: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core data: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
