//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class MainListDetailViewController: UITableViewController {
    
    var delegate: MainListDetailViewControllerDelegate?
    var itemToEdit: Checklist?
    
    override func viewWillAppear(_ animated: Bool) {
        becomeFirstResponder()
        if(itemToEdit != nil) {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(itemToEdit != nil) {
            self.title = "Edit a checklist"
            textFieldChecklist.text = itemToEdit?.name
        }
        else { self.title = "Add a checklist" }
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textFieldChecklist: UITextField!
    
    @IBAction func Cancel() {
        delegate?.mainListDetailViewControllerDidCancel(self)
    }
    
    @IBAction func Done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.name = textFieldChecklist.text!
            delegate?.mainListDetailViewController(self, didFinishEditingChecklist: itemToEdit)
        } else {
            delegate?.mainListDetailViewController(self, didFinishAddingChecklist: Checklist(name: textFieldChecklist.text!))
        }
    }
}



protocol MainListDetailViewControllerDelegate : class {
    func mainListDetailViewControllerDidCancel(_ controller: MainListDetailViewController)
    func mainListDetailViewController(_ controller: MainListDetailViewController, didFinishAddingChecklist item: Checklist)
    func mainListDetailViewController(_ controller: MainListDetailViewController, didFinishEditingChecklist item: Checklist)
}


extension MainListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = textFieldChecklist.text!
        let newString = oldString.replacingCharacters(in: (Range(range, in: oldString))!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }
}
