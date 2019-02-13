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
//    let persistentContainer: NSPersistentContainer
    
    let backgroundContext: NSManagedObjectContext
    
    init(backgroundContext: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - CRUD
    func createFoodCategory(name: String, imageUrl: String?) {
        backgroundContext.performAndWait {
            guard let foodCategory = NSEntityDescription.insertNewObject(forEntityName: String(describing: FoodCategory.self), into: backgroundContext) as? FoodCategory else {
                fatalError("CoreData type mis-match")
            }
            
            foodCategory.name = name
            foodCategory.imageURL = imageUrl
            try? backgroundContext.save()
        }
    }
    
    func updateFoodCategory(foodCategory: FoodCategory, name: String, imageUrl: String?) {
        let objectId = foodCategory.objectID
        backgroundContext.performAndWait {
            if let categoryInContext = try? backgroundContext.existingObject(with: objectId), let categoryToUpdate = categoryInContext as? FoodCategory {
                categoryToUpdate.name = name
                categoryToUpdate.imageURL = imageUrl
                try? backgroundContext.save()
            }
        }
    }
    
    func deleteFoodCategory(foodCategory: FoodCategory) {
        let objectId = foodCategory.objectID
        backgroundContext.performAndWait {
            if let categoryInContext = try? backgroundContext.existingObject(with: objectId) {
                backgroundContext.delete(categoryInContext)
                try? backgroundContext.save()
            }
        }
    }
}
