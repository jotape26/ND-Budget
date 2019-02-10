//
//  Expense.swift
//  Budget
//
//  Created by João Leite on 07/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseFirestore

class Expense : Mappable {

    var expenseName: String?
    var expenseValue: Double?
    var expenseDate: Date?
    var category: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        expenseName = try? map.value("expense_name")
        expenseValue = try? map.value("expense_value")
        
        if let timestamp = try? map.value("created_at") as Timestamp {
            expenseDate = timestamp.dateValue()
        }
        
        category = try? map.value("category")
    }
}
