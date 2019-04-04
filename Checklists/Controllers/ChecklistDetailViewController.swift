//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class ChecklistDetailViewController: UITableViewController {
    
    var delegate: ChecklistDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewWillAppear(_ animated: Bool) {
        becomeFirstResponder()
        buttonDone.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(itemToEdit != nil) {
            self.title = "Edit an item"
            checklistDetailsTextFiled.text = itemToEdit?.text
        }
        else { self.title = "Add an item" }
    }
    
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var checklistDetailsTextFiled: UITextField!
    
    
    @IBAction func Cancel() { delegate?.checklistDetailViewControllerDidCancel(self) }
    
    @IBAction func Done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = checklistDetailsTextFiled.text!
            delegate?.checklistDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else { delegate?.checklistDetailViewController(self, didFinishAddingItem: ChecklistItem(text: checklistDetailsTextFiled.text!)) }
    }
}



protocol ChecklistDetailViewControllerDelegate : class {
    func checklistDetailViewControllerDidCancel(_ controller: ChecklistDetailViewController)
    func checklistDetailViewController(_ controller: ChecklistDetailViewController, didFinishAddingItem item: ChecklistItem)
    func checklistDetailViewController(_ controller: ChecklistDetailViewController, didFinishEditingItem item: ChecklistItem)
}


extension ChecklistDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = checklistDetailsTextFiled.text!
        let newString = oldString.replacingCharacters(in: (Range(range, in: oldString))!, with: string)
        buttonDone.isEnabled = !newString.isEmpty
        return true
    }
}
