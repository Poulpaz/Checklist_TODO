//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController {
    
    var delegate: ListDetailViewControllerDelegate?
    var itemToEdit: Checklist?
    
    override func viewWillAppear(_ animated: Bool) {
        becomeFirstResponder()
        doneButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(itemToEdit != nil) {
            self.title = "Edit a checklist"
            //TextField.text = itemToEdit?.text
        }
        else { self.title = "Add a checklist" }
    }
    
    @IBAction func Cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func Done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.name = textFieldChecklist.text!
            delegate?.listDetailViewController(self, didFinishEditingChecklist: itemToEdit)
        } else {
            guard let text = textFieldChecklist.text else {
                return
            }
            delegate?.listDetailViewController(self, didFinishAddingChecklist: Checklist(name: text))
        }
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textFieldChecklist: UITextField!
}

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist item: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist item: Checklist)
}

extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldString = textFieldChecklist.text!
        let newString = oldString.replacingCharacters(in: (Range(range, in: oldString))!, with: string)
        doneButton.isEnabled = !newString.isEmpty
        return true
    }
}
