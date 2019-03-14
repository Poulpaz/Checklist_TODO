//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var checklistItems = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell1 = ChecklistItem.init(text: "Booker Aslove")
        
        checklistItems.append(cell1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return checklistItems.count; }
    
    //datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CheckListItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! CheckListItemCell
        configureText(for: cell, withItem: checklistItems[indexPath.row])
        configureCheckmark(for: cell, withItem: checklistItems[indexPath.row])
        return cell
    }
    
    
    
    
    func configureText(for cell: CheckListItemCell, withItem item: ChecklistItem) {
        cell.contentLabel?.text = item.text
    }
    
    func configureCheckmark(for cell: CheckListItemCell, withItem item: ChecklistItem) {
        cell.checkMarkLabel.isHidden = !item.checked
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! AddItemViewController
            destVC.delegate = self
        }
        if(segue.identifier == "editItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! AddItemViewController
            let indexPath = tableView.indexPath(for: sender as! CheckListItemCell)!
            destVC.itemToEdit = self.checklistItems[indexPath.row]
            destVC.delegate = self
        }
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checklistItems[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklistItems.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        checklistItems.append(item)
        controller.dismiss(animated: true)
        tableView.insertRows(at: [IndexPath(row: checklistItems.count - 1, section: 0)], with: .automatic)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem) {
        let row = checklistItems.index( where: { $0 === item})!
        controller.dismiss(animated: true)
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}
