//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class MainListViewController : UITableViewController {
    
    //MARK : Attributes
    var lists = [Checklist]()
    
    // Document link's folder
    static var documentDirectory: URL { return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first! }
    
    // Checklists.json link's file
    static var dataFileUrl: URL { return MainListViewController.documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json") }
    
    //MARK : At create view
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChecklistItems()
        print(MainListViewController.dataFileUrl)
    }
    
    
    
    //MARK : Serialize / Deserialize Data to / from Checklist.json
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.lists)
            try data.write(to: MainListViewController.dataFileUrl, options: [])
        }
        catch { print(error) }
    }
    
    func loadChecklistItems() {
        do {
            let data = try Data(contentsOf: MainListViewController.dataFileUrl)
            let decoder = JSONDecoder()
            self.lists = try decoder.decode([Checklist].self, from: data)
        }
        catch { print(error) }
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
            destVC.checklist = self.lists[indexPath.row]
            destVC.delegate = self
        }
        if(segue.identifier == "addChecklist") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! MainListDetailViewController
            destVC.delegate = self
        }
        if(segue.identifier == "editChecklist") {
            let navVC = segue.destination as! UINavigationController
            let destVC = navVC.topViewController as! MainListDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            destVC.itemToEdit = self.lists[indexPath.row]
            destVC.delegate = self
        }
    }
    
    
    
    
    //MARK : tableView settings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true) }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        saveChecklistItems()
    }
}



//MARK : Extensions
extension MainListViewController: MainListDetailViewControllerDelegate {
    func mainListDetailViewControllerDidCancel(_ controller: MainListDetailViewController) { controller.dismiss(animated: true) }
    
    func mainListDetailViewController(_ controller: MainListDetailViewController, didFinishAddingChecklist item: Checklist) {
        lists.append(item)
        controller.dismiss(animated: true)
        tableView.insertRows(at: [IndexPath(row: lists.count - 1, section: 0)], with: .automatic)
        saveChecklistItems()
    }
    
    func mainListDetailViewController(_ controller: MainListDetailViewController, didFinishEditingChecklist item: Checklist) {
        let row = lists.index( where: { $0 === item})!
        controller.dismiss(animated: true)
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        saveChecklistItems()
    }
}

extension MainListViewController: ChecklistViewControllerDelegate {
    func checklistViewController(_ controller: ChecklistViewController, didViewWillDisappear list: Checklist) { saveChecklistItems() }
}
