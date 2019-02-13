//
//  UIViewController+Helpers.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-13.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
extension UIViewController {
    func presentAlertView(title: String) {
        let alert = UIAlertController(title: "Please enter a name", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
