//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class AllListViewController : UITableViewController {
    
    //MARK : Attributes
    var lists = [Checklist]()
    
    //MARK : At create view
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell1 = Checklist(name: "Artistes")
        let cell2 = Checklist(name: "Staff")
        let cell3 = Checklist(name: "Locations")
        let cell4 = Checklist(name: "Contacts")
        lists.append(cell1)
        lists.append(cell2)
        lists.append(cell3)
        lists.append(cell4)
    }
    
    //MARK : Items' properties & Items' configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return lists.count; }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCheckList", for: indexPath)
        configureText(for: cell, withItem: lists[indexPath.row])
        return cell
    }
    
    func configureText(for cell: UITableViewCell, withItem item: Checklist) { cell.textLabel?.text = item.name }
    
    
    //MARK : Segue properties
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "itemList") {
            let destVC = segue.destination as! ChecklistViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.list = self.lists[indexPath.row].items
            destVC.name = self.lists[indexPath.row].name
        }
        if(segue.identifier == "addChecklist") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            destVC.delegate = self
        }
        if(segue.identifier == "editChecklist") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ListDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.itemToEdit = self.lists[indexPath.row]
            destVC.delegate = self
        }
    }
    
    
    //MARK : tableView settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true) }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

//MARK : Extensions
extension AllListViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist item: Checklist) {
        lists.append(item)
        controller.dismiss(animated: true)
        tableView.insertRows(at: [IndexPath(row: lists.count - 1, section: 0)], with: .automatic)
        //self.saveChecklistItems()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist item: Checklist) {
        let row = lists.index( where: { $0 === item})!
        controller.dismiss(animated: true)
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        //self.saveChecklistItems()
    }
}
