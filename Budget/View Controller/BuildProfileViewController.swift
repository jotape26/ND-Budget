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
        
        lbUserName = HelperMethods.customizeTextField(lbUserName)
        budgetTextField = HelperMethods.customizeTextField(budgetTextField)
        
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
        if let budgetText = budgetTextField.text {
            
            if let budgetValue = HelperMethods.processValue(budgetText) {
                let userInfo = ["budget" : budgetValue] as [String: Any]
                
                FirebaseService.createDBInfo(userInfo)
                UserDefaults.standard.set(budgetValue, forKey: "userBudget")
                UserDefaults.standard.set(true, forKey: "profileCompleted")
                self.performSegue(withIdentifier: "ProfileToMainSegue", sender: nil)
            } else {
                print("fuck")
            }
        }
    }
}
