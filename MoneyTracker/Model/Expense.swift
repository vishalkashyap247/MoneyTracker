//
//  Expense.swift
//  MoneyTracker
//
//  Created by Vishal Kashyap on 03/03/24.
//

import Foundation
import SwiftData

// Macro for swift data, Right click and expand macro - to see underground functionalities.
@Model
class Expense {
    // Must be unique item.
    @Attribute(.unique) var name: String
    var date: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
