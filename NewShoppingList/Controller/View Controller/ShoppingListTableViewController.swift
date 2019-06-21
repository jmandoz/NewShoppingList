//
//  ShoppingListTableViewController.swift
//  NewShoppingList
//
//  Created by Jason Mandozzi on 6/21/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewShoppingListController.shared.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NewShoppingListController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell
     
     // Configure the cell...
        
        guard let item = NewShoppingListController.shared.fetchedResultsController.fetchedObjects?[indexPath.row]
            else {return UITableViewCell()}
        
        cell?.textLabel?.text = item.name
        cell?.delegate = self
     
        return cell ?? UITableViewCell()
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            guard let Item = NewShoppingListController.shared.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            NewShoppingListController.shared.remove(Item: Item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        showAlert()
    }
    func showAlert()
    {
        let alertController = UIAlertController(title: "Add a Item", message: "What we buying today?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text else {return}
            NewShoppingListController.shared.add(name: name)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No Thanks", style: .destructive)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension ShoppingListTableViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let item = NewShoppingListController.shared.fetchedResultsController.object(at: indexPath)
        NewShoppingListController.shared.toggleIsComplete(Item: item)
        sender.update(Item: item)
    }
}

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}
