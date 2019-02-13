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
    // MARK: - IBOutlets and IBActions
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func reorderButtonPressed(_ sender: Any) {
        
    }
    
    // MARK: Invars
    private let foodCategoryDataManager = FoodCategoryDataManager()
    
    private let filePathManager = FilePathManager()
    
    private lazy var fetchedResultsControllerDelegateHandler: TableViewFetchedResultsControllerDelegateHandler = {
        return TableViewFetchedResultsControllerDelegateHandler(tableView: self.tableView)
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FoodCategory> = {
        let fetchRequest = NSFetchRequest<FoodCategory>(entityName: String(describing: FoodCategory.self))
        let sortDescriptor = NSSortDescriptor(key: "orderIndex", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self.fetchedResultsControllerDelegateHandler
        
        return fetchedResultsController
    }()
    
    // MARK: - View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        case Strings.SegueIds.foodItemPageSegueId:
            if let vc = segue.destination as? FoodItemViewController, let indexPath = sender as? IndexPath, let foodCategory = fetchedResultsController.fetchedObjects?[indexPath.row] {
                vc.foodCategory = foodCategory
            }
        case Strings.SegueIds.editFoodCategorySegueId:
            if let indexPath = sender as? IndexPath, let vc = segue.destination as? EditFoodCategoryViewController {
                guard let foodCategory = fetchedResultsController.fetchedObjects?[indexPath.row] else {
                    return
                }
                vc.isEdit = true
                vc.foodCategory = foodCategory
            }
        default:
            return
        }
    }
}

// MARK: - Table view data source methods
extension FoodCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueCategoryCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    // MARK: - Helpers
    private func dequeueCategoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }

        guard let foodCategory = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let imageUrl = foodCategory.imageURL, filePathManager.fileManager.fileExists(atPath: imageUrl), let fileContents = UIImage(contentsOfFile: imageUrl) {
            cell.configure(name: foodCategory.name, image: fileContents, price: nil)
        } else {
            cell.configure(name: foodCategory.name, image: nil, price: nil)
        }
        
        return cell
    }
}

// MARK: - Table view data source delegate methods
extension FoodCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Strings.SegueIds.foodItemPageSegueId, sender: indexPath)
    }
    
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
        performSegue(withIdentifier: Strings.SegueIds.editFoodCategorySegueId, sender: indexPath)
    }
    
    private func deleteActionHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        guard let foodCategory = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return
        }
        foodCategoryDataManager.deleteFoodCategory(foodCategory: foodCategory)
        //TODO: delete image data from file path
    }
}

