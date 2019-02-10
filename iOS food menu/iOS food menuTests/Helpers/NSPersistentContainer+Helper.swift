//
//  NSPersistentContainer+Helper.swift
//  iOS food menuTests
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
import CoreData
@testable import iOS_food_menu

extension NSPersistentContainer {
    func destroyPersistentStore() {
        guard let storeURL = persistentStoreDescriptions.first?.url,
            let storeType = persistentStoreDescriptions.first?.type else {
                return
        }
        
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: storeType, options: nil)
        } catch let error {
            print("failed to destroy persistent store at \(storeURL), error: \(error)")
        }
    }
}
