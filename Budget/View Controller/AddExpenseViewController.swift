//
//  AddExpenseViewController.swift
//  Budget
//
//  Created by João Leite on 09/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var txtExpenseName: UITextField!
    @IBOutlet weak var txtExpenseValue: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveExpenseClicked(_ sender: Any) {
        guard let name = txtExpenseName.text else { return }
        guard let valueText = txtExpenseValue.text else { return }
        guard let value = Double(valueText) else  { return }
        
        let params = ["expense_name" : name,
                      "expense_value" : value,
                      "created_at": Date()] as [String : Any]
        
        FirebaseService.createNewExpense(params) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
