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
    var checklistItemsList = [ChecklistItem]()
    
    //MARK : At create view
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell1 = ChecklistItem(text: "Artistes")
        let cell2 = ChecklistItem(text: "Staff")
        let cell3 = ChecklistItem(text: "Location")
        checklistItemsList.append(cell1)
        checklistItemsList.append(cell2)
        checklistItemsList.append(cell3)
    }
    
    //MARK : Items' properties & Items' configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return checklistItemsList.count; }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemList", for: indexPath)
        configureText(for: cell, withItem: checklistItemsList[indexPath.row])
        return cell
    }
    
    func configureText(for cell: UITableViewCell, withItem item: ChecklistItem) { cell.textLabel?.text = item.text }
    
    
    //MARK : Segue properties
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "itemList") {
            let destVC = segue.destination as! ChecklistViewController
        }
    }
    
    
    //MARK : tableView settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checklistItemsList[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //self.saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklistItemsList.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //self.saveChecklistItems()
    }
}
