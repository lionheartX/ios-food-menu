//
//  FoodCategoryViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
import CoreData

class FoodCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    
    private let foodCategoryDataManager = FoodCategoryDataManager()
    
    private lazy var fetchedResultsControllerDelegateHandler: TableViewFetchedResultsControllerDelegateHandler = {
        return TableViewFetchedResultsControllerDelegateHandler(tableView: self.tableView)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FoodCategory> = {
        let fetchRequest = NSFetchRequest<FoodCategory>(entityName: String(describing: FoodCategory.self))
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self.fetchedResultsControllerDelegateHandler
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
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
extension FoodCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }

        guard let foodCategory = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(name: foodCategory.name, image: foodCategory.imageURL, price: nil)
        return cell
    }
}
