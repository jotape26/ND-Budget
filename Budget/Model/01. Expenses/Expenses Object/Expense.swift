//
//  Expense.swift
//  Budget
//
//  Created by João Leite on 07/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation
import ObjectMapper

class Expense : Mappable {

    var expenseName: String?
    var expenseValue: Double?
    var expenseDate: Date?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        expenseName = try? map.value("name")
        expenseValue = try? map.value("value")
        expenseDate = try? map.value("date")
    }
}
