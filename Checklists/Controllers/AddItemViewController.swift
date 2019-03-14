//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    var delegate: AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewWillAppear(_ animated: Bool) {
        becomeFirstResponder()
        buttonDone.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(itemToEdit != nil) {
            self.title = "Edit an item"
            TextField.text = itemToEdit?.text
        }
        else { self.title = "Add an item" }
    }
    
    @IBAction func Cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func Done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = TextField.text!
            delegate?.addItemViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(text: TextField.text!))
        }
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var TextField: UITextField!
}

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem)
}

extension AddItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldString = TextField.text!
        let newString = oldString.replacingCharacters(in: (Range(range, in: oldString))!, with: string)
        
        buttonDone.isEnabled = !newString.isEmpty
        return true
    }
}
