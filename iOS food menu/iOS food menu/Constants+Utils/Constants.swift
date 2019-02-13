//
//  Constants.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit

struct Constants {
    static let deviceType = UIScreen.main.traitCollection.userInterfaceIdiom
    
    struct TableViews {
        static let rowHeight: CGFloat = Constants.deviceType == .phone ? 100.0 : 150.0
    }
    
}
