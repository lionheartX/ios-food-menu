//
//  FoodCategoryDataManager.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
import CoreData

class FoodCategoryDataManager {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer = CoreDataManager.shared.persistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - CRUD
    func createFoodCategory(name: String, imageUrl: String) {
        persistentContainer.performBackgroundTask { (context) in
            let foodCategory = FoodCategory(context: context)
            foodCategory.name = name
            foodCategory.imageURL = imageUrl
            try? context.save()
        }
    }
    
    func updateFoodCategory(foodCategory: FoodCategory, name: String, imageUrl: String) {
        let objectId = foodCategory.objectID
        persistentContainer.performBackgroundTask { (context) in
            if let categoryToUpdate = context.object(with: objectId) as? FoodCategory {
                categoryToUpdate.name = name
                categoryToUpdate.imageURL = imageUrl
                try? context.save()
            }
        }
    }
    
    func deleteFoodCategory(foodCategory: FoodCategory) {
        let objectId = foodCategory.objectID
        persistentContainer.performBackgroundTask { (context) in
            if let categoryInContext = try? context.existingObject(with: objectId) {
                context.delete(categoryInContext)
                try? context.save()
            }
        }
    }
}
