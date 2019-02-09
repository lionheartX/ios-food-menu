//
//  FoodItem.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import Foundation
class FoodItem {
    var name: String?
    var price: Double?
    var image: String?
    
    init(name: String?, price: Double?, image: String?) {
        self.name = name
        self.price = price
        self.image = image
    }
}
