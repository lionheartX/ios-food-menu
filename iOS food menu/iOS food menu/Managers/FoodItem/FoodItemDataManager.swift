//
//  FoodItemsDataManager.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
import CoreData


class FoodItemDataManager {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer = CoreDataManager.shared.persistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - CRUD
    func createFoodItem(name: String, imageUrl: String?, price: String) {
        persistentContainer.performBackgroundTask { (context) in
            let foodItem = FoodItem(context: context)
            foodItem.name = name
            foodItem.imageURL = imageUrl
            foodItem.price = price
            try? context.save()
        }
    }
    
    func updateFoodItem(foodItem: FoodItem, name: String, imageUrl: String?, price: String) {
        let objectId = foodItem.objectID
        persistentContainer.performBackgroundTask { (context) in
            if let itemToUpdate = context.object(with: objectId) as? FoodItem {
                itemToUpdate.name = name
                itemToUpdate.imageURL = imageUrl
                itemToUpdate.price = price
                try? context.save()
            }
        }
    }
    
    func deleteFoodItem(foodItem: FoodItem) {
        let objectId = foodItem.objectID
        persistentContainer.performBackgroundTask { (context) in
            if let foodItemInContext = try? context.existingObject(with: objectId) {
                context.delete(foodItemInContext)
                try? context.save()
            }
        }
    }
    
    // MARK: - Manage Relationship
    func assignFoodItem(_ foodItem: FoodItem, to foodCategory: FoodCategory) {
        let itemObjectId = foodItem.objectID
        let categoryObjectId = foodCategory.objectID
        persistentContainer.performBackgroundTask { (context) in
            if let item = context.object(with: itemObjectId) as? FoodItem, let category = context.object(with: categoryObjectId) as? FoodCategory {
                category.addToFoodItems(item)
                try? context.save()
            }
        }
    }
}
