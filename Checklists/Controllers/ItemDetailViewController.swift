//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    
    var delegate: ItemDetailViewControllerDelegate?
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
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func Done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = TextField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.itemDetailViewController(self, didFinishAddingItem: ChecklistItem(text: TextField.text!))
        }
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var TextField: UITextField!
}

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = TextField.text!
        let newString = oldString.replacingCharacters(in: (Range(range, in: oldString))!, with: string)
        buttonDone.isEnabled = !newString.isEmpty
        return true
    }
}
