//
//  CoreDataManager.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var storeType: String!
    
    lazy var persistentContainer: NSPersistentContainer! = {
        let persistentContainer = NSPersistentContainer(name: "iOS_food_menu")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = storeType
        return persistentContainer
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }() // commit changes to core data on the background thread
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    // MARK: - Set up
    func setup(storeType: String = NSSQLiteStoreType, completion:(() -> Void)?) {
        // supports multiple store types for the persistant container, e.g: able to use faster in-memory storage in unit tests
        self.storeType = storeType
        loadPersistentStore {
            completion?()
        }
    }

    // MARK: - Loading
    private func loadPersistentStore(completion: @escaping () -> Void) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
        }
    }
}
