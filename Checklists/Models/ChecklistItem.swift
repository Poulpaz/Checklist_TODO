//
//  ChecklistItem.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem : Codable {
    
    var text: String
    var checked: Bool
    
    init(text: String, checked:Bool = false) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
