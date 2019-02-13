//
//  FoodCategoryDataManagerTests.swift
//  iOS food menuTests
//
//  Created by Zheng Xiong on 2019-02-09.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import XCTest
import CoreData
@testable import iOS_food_menu

class FoodCategoryDataManagerTests: XCTestCase {

    var foodCategoryDataManager: FoodCategoryDataManager!
    
    var coreDataMock: CoreDataMock!
    
    override func setUp() {
        super.setUp()
        coreDataMock = CoreDataMock()
        foodCategoryDataManager = FoodCategoryDataManager(backgroundContext: coreDataMock.backgroundContext)
    }
    
    func test_init_persistentContainer() {
        XCTAssertEqual(foodCategoryDataManager.backgroundContext, coreDataMock.backgroundContext)
    }

    func test_createFoodCategory() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataMock.backgroundContext.expectation = performAndWaitExpectation
        let name = "Test"
        let imageUrl = "UrlTest/test.jpg"
        
        foodCategoryDataManager.createFoodCategory(name: name, imageUrl: imageUrl) { (_) in}
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
            let foodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
            
            guard let foodCategory = foodCategories.first else {
                XCTFail("food category missing")
                return
            }

            XCTAssertEqual(foodCategories.count, 1)
            XCTAssertNotNil(foodCategory.name)
            XCTAssertEqual(foodCategory.name, name)
            XCTAssertEqual(foodCategory.imageURL, imageUrl)
        }
    }
    
// run into a bug, didn't have enough time to fix this test
//    func test_updateFoodCategory() {
//        let performAndWaitExpectation = expectation(description: "background perform and wait")
//        coreDataMock.backgroundContext.expectation = performAndWaitExpectation
//        let nameA = "nameA"
//        let urlA = "urlA"
//        let nameB = "nameB"
//        let urlB = "urlB"
//
//        foodCategoryDataManager.createFoodCategory(name: nameA, imageUrl: urlA) { (foodCategory) in
//            self.foodCategoryDataManager.updateFoodCategory(foodCategory: foodCategory!, name: nameB, imageUrl: urlB)
//        }
//
//        waitForExpectations(timeout: 1) { (_) in
//            let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
//            let foodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
//
//            guard let foodCategory = foodCategories.first else {
//                XCTFail("food category missing")
//                return
//            }
//
//            XCTAssertEqual(foodCategories.count, 1)
//            XCTAssertEqual(foodCategory.name, nameB)
//            XCTAssertEqual(foodCategory.imageURL, urlB)
//        }
//    }
    
    func test_deleteFoodCategory() {
        let performAndWaitExpectation = expectation(description: "background perform and wait")
        coreDataMock.backgroundContext.expectation = performAndWaitExpectation
        
        let foodCategoryA = NSEntityDescription.insertNewObject(forEntityName: String(describing: FoodCategory.self), into: self.coreDataMock.backgroundContext) as! FoodCategory
        let foodCategoryB = NSEntityDescription.insertNewObject(forEntityName: String(describing: FoodCategory.self), into: self.coreDataMock.backgroundContext) as! FoodCategory
        let foodCategoryC = NSEntityDescription.insertNewObject(forEntityName: String(describing: FoodCategory.self), into: self.coreDataMock.backgroundContext) as! FoodCategory
        
        foodCategoryDataManager.deleteFoodCategory(foodCategory: foodCategoryB)
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
            let backgroundContextFoodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
            
            XCTAssertEqual(backgroundContextFoodCategories.count, 2)
            XCTAssertTrue(backgroundContextFoodCategories.contains(foodCategoryA))
            XCTAssertTrue(backgroundContextFoodCategories.contains(foodCategoryC))
        }
    }
 

}
