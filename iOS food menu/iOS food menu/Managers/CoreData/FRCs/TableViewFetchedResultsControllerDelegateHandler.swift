//
//  TableViewFetchedResultsControllerDelegateHandler.swift
//  iOS food menu
//
//  Created by Zheng Xiong on 2019-02-10.
//  Copyright © 2019 Zheng Xiong. All rights reserved.
//

import UIKit
import CoreData

class TableViewFetchedResultsControllerDelegateHandler: NSObject {
    private let tableView: UITableView
    
    fileprivate var insertionChanges = [IndexPath]()
    fileprivate var updateChanges = [IndexPath]()
    fileprivate var moveChanges = [[IndexPath]]()
    fileprivate var deletionChanges = [IndexPath]()
    
    // MARK: - Init
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
}

extension TableViewFetchedResultsControllerDelegateHandler: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertionChanges.removeAll()
        deletionChanges.removeAll()
        moveChanges.removeAll()
        updateChanges.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.performBatchUpdates({
            if insertionChanges.count > 0 {
                tableView.insertRows(at: insertionChanges, with: .fade)
            }
            
            if deletionChanges.count > 0 {
                tableView.deleteRows(at: deletionChanges, with: .fade)
            }
            
            if moveChanges.count > 0 {
                for indexPaths in moveChanges {
                    tableView.moveRow(at: indexPaths[0], to: indexPaths[1])
                }
            }
            
            if updateChanges.count > 0 {
                tableView.reloadRows(at: updateChanges, with: .fade)
            }
        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            insertionChanges.append(newIndexPath!)
        case .delete:
            deletionChanges.append(indexPath!)
        case .move:
            moveChanges.append([indexPath!, newIndexPath!])
        case .update:
            updateChanges.append(indexPath!)
        }
    }
}
