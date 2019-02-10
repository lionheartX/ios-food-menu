//
//  CategoriesViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    let foodItem0 = FoodItem(name: "Apple Pancake", price: 5.99, imageUrl: nil)
//    let foodItem1 = FoodItem(name: "Blueberry Pancake", price: 6.99, imageUrl: nil)
//
//    var food0 = Category(name: "Pancake", imageUrl: nil, foodItems: nil)
//    let food1 = Category(name: "Eggs", imageUrl: nil, foodItems: nil)
//    let food2 = Category(name: "Cheese", imageUrl: nil, foodItems: nil)
//
//    var foodList = [Category]()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        food0.foodItems = [foodItem0, foodItem1]
//        foodList = [food0, food1, food2]
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CustomCell.self), bundle: nil),
                                      forCellReuseIdentifier: String(describing: CustomCell.self))
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
//        case Strings.SegueIds.foodItemPageSegueId:
//            if let vc = segue.destination as? FoodItemViewController, let categoryIndexPath = sender as? IndexPath {
//                vc.set(category: self.foodList[categoryIndexPath.row])
//            }
        default:
            return
        }
    }
 

}

// MARK: - Table view data source and delegate methods
extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueCategoryCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Strings.SegueIds.foodItemPageSegueId, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() // gets rid of the unnecessary table view seperators at bottom
    }
    
    private func dequeueCategoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
//        guard let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
//            return UITableViewCell()
//        }
//
//        let category = foodList[indexPath.row]
//        cell.configure(name: category.name, image: category.imageUrl, price: nil)
//        return cell
    }
}
