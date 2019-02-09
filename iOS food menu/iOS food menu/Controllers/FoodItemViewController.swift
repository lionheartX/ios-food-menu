//
//  FoodItemViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit

class FoodItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?

    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(category: self.category)
        configureTableView()
    }
    
    func configure(category: Category?) {
        navTitle.title = category?.name
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CustomCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CustomCell.self))
    }
    
    func set(category: Category) {
        self.category = category
    }

}

extension FoodItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueFoodItemCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() // gets rid of the unnecessary table view seperators at bottom
    }
    
    private func dequeueFoodItemCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        guard let category = self.category else {
            return UITableViewCell()
        }
        
        guard let foodItems = category.foodItems else {
            return UITableViewCell()
        }
        
        guard indexPath.row < foodItems.count else {
            return UITableViewCell()
        }
        
        let roundedPrice = ((foodItems[indexPath.row].price ?? 0) * 100).rounded()/100 // round a Double to 2 digits after decimal
        
        cell.configure(name: foodItems[indexPath.row].name, image: foodItems[indexPath.row].image, price: String(roundedPrice))
        return cell
    }
    
    
    
}
