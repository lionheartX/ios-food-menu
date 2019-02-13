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
    let backgroundContext: NSManagedObjectContext
    
    init(backgroundContext: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.backgroundContext = backgroundContext
    }
    
    
    
    // MARK: - CRUD
    func createFoodItem(name: String, imageUrl: String?, price: String, completion: @escaping(FoodItem?) -> Void) {
        backgroundContext.performAndWait {
            guard let foodItem = NSEntityDescription.insertNewObject(forEntityName: String(describing: FoodItem.self), into: backgroundContext) as? FoodItem else {
                fatalError("CoreData type mis-match")
            }
            foodItem.name = name
            foodItem.imageURL = imageUrl
            foodItem.price = price
            do {
                try backgroundContext.save()
                completion(foodItem)
            } catch {
                completion(nil)
            }
        }
    }
    
    func updateFoodItem(foodItem: FoodItem, name: String, imageUrl: String?, price: String) {
        let objectId = foodItem.objectID
        backgroundContext.performAndWait {
            if let itemInContext = try? backgroundContext.existingObject(with: objectId), let itemToUpdate = itemInContext as? FoodItem {
                itemToUpdate.name = name
                itemToUpdate.imageURL = imageUrl
                itemToUpdate.price = price
                try? backgroundContext.save()
            }
        }
    }
    
    func deleteFoodItem(foodItem: FoodItem) {
        let objectId = foodItem.objectID
        backgroundContext.performAndWait {
            if let foodItemInContext = try? backgroundContext.existingObject(with: objectId) {
                backgroundContext.delete(foodItemInContext)
                try? backgroundContext.save()
            }
        }
    }
    
    // MARK: - Manage Relationship
    func assignFoodItem(_ foodItem: FoodItem, to foodCategory: FoodCategory) {
        let itemObjectId = foodItem.objectID
        let categoryObjectId = foodCategory.objectID
        backgroundContext.performAndWait {
            if let category = backgroundContext.object(with: categoryObjectId) as? FoodCategory, let item = backgroundContext.object(with: itemObjectId) as? FoodItem {
                category.addToFoodItems(item)
                try? backgroundContext.save()
            }
        }
    }
}
