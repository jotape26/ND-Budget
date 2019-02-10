//
//  BuildProfileViewController.swift
//  Budget
//
//  Created by João Leite on 10/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class BuildProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lbUserName: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        completeButton.layer.cornerRadius = 3
        
        if let username = UserDefaults.standard.string(forKey: "userName") {
            self.lbUserName.text = username
        } else {
            self.lbUserName.text = ""
        }
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        budgetTextField.addTarget(self, action: #selector(budgetChanged), for: .editingChanged)
        
        ImageService.downloadUserImage { (userImage) in
            DispatchQueue.main.async {
                self.userImage.image = userImage
            }
        }
    }
    

    @objc func budgetChanged(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @IBAction func completeButtonClicked(_ sender: Any) {
        if let trimmedBudgetString = budgetTextField.text {
            let budgetString = trimmedBudgetString
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: NumberFormatter().groupingSeparator, with: "")
            
            if let budgetValue = Double(budgetString) {
                let userInfo = ["budget" : budgetValue] as [String: Any]
                
                FirebaseService.createDBInfo(userInfo)
                UserDefaults.standard.set(true, forKey: "profileCompleted")
                self.performSegue(withIdentifier: "ProfileToMainSegue", sender: nil)
            } else {
                print("fuck")
            }
        }
    }
}

extension String {
    
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
