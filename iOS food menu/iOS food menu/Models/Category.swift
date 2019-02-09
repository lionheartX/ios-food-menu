//
//  Category.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
class Category {
    var name: String?
    var image: String?
    var foodItems: [FoodItem]?
    
    init(name: String?, image: String?, foodItems: [FoodItem]?) {
        self.name = name
        self.image = image
        self.foodItems = foodItems
    }
}
