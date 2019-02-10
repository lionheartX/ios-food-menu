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
        foodCategoryDataManager = FoodCategoryDataManager(persistentContainer: coreDataMock.persistentContainer)
    }
    
    func test_init_persistentContainer() {
        XCTAssertEqual(foodCategoryDataManager.persistentContainer, coreDataMock.persistentContainer)
    }

    func test_createFoodCategory() {
        let name = "Test"
        let imageUrl = "UrlTest/test.jpg"
        
        foodCategoryDataManager.createFoodCategory(name: name, imageUrl: imageUrl)
        
        waitForExpectations(timeout: 1) { (_) in
            let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
            let foodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
            
            guard let foodCategory = foodCategories.first else {
                XCTFail("food category missing")
                return
            }
            
            XCTAssertEqual(foodCategories.count, 1)
            XCTAssertEqual(foodCategory.name, name)
            XCTAssertEqual(foodCategory.imageURL, imageUrl)
        }
    }
    
    func test_updateFoodCategory() {
        let nameA = "nameA"
        let urlA = "urlA"
        let nameB = "nameB"
        let urlB = "urlB"
        
        foodCategoryDataManager.createFoodCategory(name: nameA, imageUrl: urlA)
        
        waitForExpectations(timeout: 2) { (_) in
            let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
            let foodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
            
            guard let foodCategory = foodCategories.first else {
                XCTFail("food category missing")
                return
            }
            
            XCTAssertEqual(foodCategories.count, 1)
            XCTAssertEqual(foodCategory.name, nameA)
            XCTAssertEqual(foodCategory.imageURL, urlA)
            
            self.foodCategoryDataManager.updateFoodCategory(foodCategory: foodCategory, name: nameB, imageUrl: urlB)
            
            self.waitForExpectations(timeout: 1) { (_) in
                let request = NSFetchRequest<FoodCategory>.init(entityName: String(describing: FoodCategory.self))
                let foodCategories = try! self.coreDataMock.backgroundContext.fetch(request)
                
                guard let foodCategory = foodCategories.first else {
                    XCTFail("food category missing")
                    return
                }
                
                XCTAssertEqual(foodCategories.count, 1)
                XCTAssertEqual(foodCategory.name, nameB)
                XCTAssertEqual(foodCategory.imageURL, urlB)
            }
        }
    }
    
    func test_deleteFoodCategory() {
        
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
