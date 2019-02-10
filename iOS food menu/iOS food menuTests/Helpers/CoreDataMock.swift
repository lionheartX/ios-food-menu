//
//  CoreDataMock.swift
//  iOS food menuTests
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import XCTest
import CoreData
@testable import iOS_food_menu

class CoreDataMock {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContextMock
    let mainContext: NSManagedObjectContextMock
    
    init() {
        persistentContainer = NSPersistentContainer(name: "iOS_food_menu")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContextMock(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContextMock(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}

class NSManagedObjectContextMock: NSManagedObjectContext {
    var expectation: XCTestExpectation?
    var saveWasCalled = false
    
    override func save() throws {
        try super.save()
        saveWasCalled = true
    }
}
