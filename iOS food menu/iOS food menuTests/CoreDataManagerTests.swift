//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import XCTest
import CoreData
@testable import iOS_food_menu

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager?

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager()
    }

    func test_setup_completionCalled() {
        let setupExpectation = expectation(description: "set up completion called")
        // use In-memory store type for default unit tests for faster testing
        coreDataManager?.setup(storeType: NSInMemoryStoreType) {
            setupExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_setup_persistentStoreCreated() {
        let setupExpectation = expectation(description: "set up persistent store created")
        
        coreDataManager?.setup(storeType: NSInMemoryStoreType) {
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertTrue((self.coreDataManager?.persistentContainer.persistentStoreCoordinator.persistentStores.count ?? 0) > 0)
        }
        
    }
    
    func test_setup_persistentContainerLoadedOnDisk() {
        let setupExpectation = expectation(description: "set up persistent container loaded on disk")
        
        coreDataManager?.setup {
            XCTAssertEqual(self.coreDataManager?.persistentContainer.persistentStoreDescriptions.first?.type, NSSQLiteStoreType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            self.coreDataManager?.persistentContainer.destroyPersistentStore()
        }
    }
    
    func test_setup_persistentContainerLoadedInMemory() {
        let setupExpectation = expectation(description: "set up persistent container loaded in memory")
        
        coreDataManager?.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.coreDataManager?.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_backgroundContext() {
        let setupExpectation = expectation(description: "set up background context")
        
        coreDataManager?.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.coreDataManager?.backgroundContext.concurrencyType, .privateQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_mainContext() {
        let setupExpectation = expectation(description: "set up main context")
        
        coreDataManager?.setup(storeType: NSInMemoryStoreType) {
            XCTAssertEqual(self.coreDataManager?.mainContext.concurrencyType, .mainQueueConcurrencyType)
            setupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}
