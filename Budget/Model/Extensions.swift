//
//  Extensions.swift
//  Budget
//
//  Created by João Leite on 10/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

class HelperMethods {
    
    static func customizeTextField( _ textView: UITextField) -> UITextField {
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textView.frame.size.height - 2.0, width: textView.frame.size.width, height: textView.frame.size.height)
        
        border.borderWidth = 2.0
        
        textView.layer.addSublayer(border)
        textView.layer.masksToBounds = true
        return textView
    }
    
    static func processValue(_ budgetText: String) -> NSNumber? {
            
            let form = NumberFormatter()
            let budgetString = budgetText
                .replacingOccurrences(of: form.currencySymbol, with: "")
                .replacingOccurrences(of: form.groupingSeparator, with: "")
            
            if let budgetValue = form.number(from: budgetString) {
                return budgetValue
            }
        return nil
    }
    
}
