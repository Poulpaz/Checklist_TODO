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
        
        let cell1 = ChecklistItem.init(text: "Terminer l'appli iOS")
        let cell2 = ChecklistItem.init(text: "Passer prendre une bière", checked: true)
        let cell3 = ChecklistItem.init(text: "Location matériel bar et boissons (Juradis)")
        let cell4 = ChecklistItem.init(text: "Commander EcoCup")
        let cell5 = ChecklistItem.init(text: "Booker l'artiste (Aslove)", checked: true)
        let cell6 = ChecklistItem.init(text: "Valider devis Arami Séc.", checked: true)
        
        checklistItems.append(cell1)
        checklistItems.append(cell2)
        checklistItems.append(cell3)
        checklistItems.append(cell4)
        checklistItems.append(cell5)
        checklistItems.append(cell6)
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
        cell.checkMarkLabel.isHidden = item.checked
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let destVC = navVC.topViewController as! AddItemViewController
        destVC.delegate = self
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
        self.loadView()
        controller.dismiss(animated: true)
    }
}
