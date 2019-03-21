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
    var list = [ChecklistItem]()
    var name: String!
    
    
    // Document link's folder
    static var documentDirectory: URL { return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first! }
    
    // Checklists.json link's file
    static var dataFileUrl: URL { return ChecklistViewController.documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json") }
 
    
    //MARK : At create view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.name
        //self.loadChecklistItems()
    }
    
    
    //MARK : Items' properties & Items' configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return list.count; }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CheckListItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as! CheckListItemCell
        configureText(for: cell, withItem: list[indexPath.row])
        configureCheckmark(for: cell, withItem: list[indexPath.row])
        return cell
    }
    
    func configureText(for cell: CheckListItemCell, withItem item: ChecklistItem) { cell.contentLabel?.text = item.text }
    
    func configureCheckmark(for cell: CheckListItemCell, withItem item: ChecklistItem) { cell.checkMarkLabel.isHidden = !item.checked }
    
    
    //MARK : Segue properties
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            destVC.delegate = self
        }
        if(segue.identifier == "editItem") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! ItemDetailViewController
            let indexPath = tableView.indexPath(for: sender as! CheckListItemCell)!
            destVC.itemToEdit = self.list[indexPath.row]
            destVC.delegate = self
        }
    }
    
    
    //MARK : tableView settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        //self.saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //self.saveChecklistItems()
    }
    
    
    //MARK : Serialize / Deserialize Data to / from Checklist.json
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.list)
            try data.write(to: ChecklistViewController.dataFileUrl, options: [])
        }
        catch { print(error) }
    }
    
    func loadChecklistItems() {
        do {
            let data = try Data(contentsOf: ChecklistViewController.dataFileUrl)
            let decoder = JSONDecoder()
            self.list = try decoder.decode([ChecklistItem].self, from: data)
        }
        catch { print(error) }
    }
}


    //MARK : Extensions
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) { controller.dismiss(animated: true) }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        list.append(item)
        controller.dismiss(animated: true)
        tableView.insertRows(at: [IndexPath(row: list.count - 1, section: 0)], with: .automatic)
        //self.saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        let row = list.index( where: { $0 === item})!
        controller.dismiss(animated: true)
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        //self.saveChecklistItems()
    }
}
