//
//  FoodItemViewController.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-07.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
import CoreData

class FoodItemViewController: UIViewController {
    // MARK: - IBOutlets and IBActions
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var navTitle: UINavigationItem!
    
    // MARK: Invars
    var foodCategory: FoodCategory?
    
    private let foodItemDataManager = FoodItemDataManager()
    
    private let filePathManager = FilePathManager()
    
    private lazy var fetchedResultsControllerDelegateHandler: TableViewFetchedResultsControllerDelegateHandler = {
        return TableViewFetchedResultsControllerDelegateHandler(tableView: self.tableView)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FoodItem> = {
        let fetchRequest = NSFetchRequest<FoodItem>(entityName: String(describing: FoodItem.self))
        let sortDescriptor = NSSortDescriptor(key: "orderIndex", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self.fetchedResultsControllerDelegateHandler
        
        return fetchedResultsController
    }()
    
    // MARK: - View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(foodCategory: self.foodCategory)
        configureTableView()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }
    
    func configure(foodCategory: FoodCategory?) {
        navTitle.title = foodCategory?.name ?? "Food Item"
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
        case Strings.SegueIds.editFoodItemSegueId:
            if let indexPath = sender as? IndexPath, let vc = segue.destination as? EditFoodItemViewController {
                guard let foodItem = fetchedResultsController.fetchedObjects? [indexPath.row] else {
                    return
                }
                vc.isEdit = true
                vc.foodItem = foodItem
            }
        default:
            return
        }
    }
}

// MARK: - Table view data source methods

extension FoodItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueFoodItemCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    private func dequeueFoodItemCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        guard let foodItem = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let imageUrl = foodItem.imageURL, filePathManager.fileManager.fileExists(atPath: imageUrl), let fileContents = UIImage(contentsOfFile: imageUrl) {
            cell.configure(name: foodItem.name, image: fileContents, price: foodItem.price)
        } else {
            cell.configure(name: foodItem.name, image: nil, price: foodItem.price)
        }
        return cell
    }
}

extension FoodItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: editActionHandler)
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteActionHandler)
        return [editAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() // gets rid of the unnecessary table view seperators at bottom
    }
    
    // MARK: - Helpers
    private func editActionHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        performSegue(withIdentifier: Strings.SegueIds.editFoodItemSegueId, sender: indexPath)
    }
    
    private func deleteActionHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        guard let foodItem = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return
        }
        foodItemDataManager.deleteFoodItem(foodItem: foodItem)
        //TODO: delete image data from file path
    }
}


