//
//  Checklist.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 sge-groupama-fdj. All rights reserved.
//

import Foundation
import UIKit

class Checklist : Codable {
    var name: String!
    var items = [ChecklistItem]()
    
    init(name: String, items: [ChecklistItem] = []) {
        self.name = name
        self.items = items
    }
}
