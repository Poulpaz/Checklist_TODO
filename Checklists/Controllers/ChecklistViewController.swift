//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit
import Foundation

class ChecklistViewController: UITableViewController {

    //MARK : Attributes
    var checklist: Checklist!
    var delegate: ChecklistViewControllerDelegate?
    
    
    //MARK : At create view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.checklist.name
    }
    
    override func viewWillDisappear(_ animated: Bool) { delegate?.checklistViewController(self, didViewWillDisappear: checklist) }
    
    
    
    //MARK : Items' properties & Items' configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return checklist.items.count; }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CheckListItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! CheckListItemCell
        configureText(for: cell, withItem: checklist.items[indexPath.row])
        configureCheckmark(for: cell, withItem: checklist.items[indexPath.row])
        return cell
    }
    
    
    
    func configureText(for cell: CheckListItemCell, withItem item: ChecklistItem) { cell.contentLabel?.text = item.text }
    
    func configureCheckmark(for cell: CheckListItemCell, withItem item: ChecklistItem) { cell.checkMarkLabel.isHidden = !item.checked }
    
    
    
    //MARK : Segue properties
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ChecklistDetailViewController
            destVC.delegate = self
        }
        if(segue.identifier == "editItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ChecklistDetailViewController
            let indexPath = tableView.indexPath(for: sender as! CheckListItemCell)!
            destVC.itemToEdit = self.checklist.items[indexPath.row]
            destVC.delegate = self
        }
    }
    
    
    //MARK : tableView settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checklist.items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}



protocol ChecklistViewControllerDelegate: class { func checklistViewController(_ controller: ChecklistViewController, didViewWillDisappear item: Checklist) }



    //MARK : Extensions
extension ChecklistViewController: ChecklistDetailViewControllerDelegate {
    func checklistDetailViewControllerDidCancel(_ controller: ChecklistDetailViewController) { controller.dismiss(animated: true) }
    
    func checklistDetailViewController(_ controller: ChecklistDetailViewController, didFinishAddingItem item: ChecklistItem) {
        checklist.items.append(item)
        controller.dismiss(animated: true)
        tableView.insertRows(at: [IndexPath(row: checklist.items.count - 1, section: 0)], with: .automatic)
    }
    
    func checklistDetailViewController(_ controller: ChecklistDetailViewController, didFinishEditingItem item: ChecklistItem) {
        let row = checklist.items.index( where: { $0 === item})!
        controller.dismiss(animated: true)
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}
