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
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtExpenseName = HelperMethods.customizeTextField(txtExpenseName)
        txtExpenseName.delegate = self
        
        txtExpenseValue = HelperMethods.customizeTextField(txtExpenseValue)
        txtExpenseValue.delegate = self
        txtExpenseValue.addTarget(self, action: #selector(budgetChanged), for: .editingChanged)
        
        txtCategory = HelperMethods.customizeTextField(txtCategory)
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtCategory.inputView = pickerView
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        saveButton.layer.cornerRadius = 10
        
    }
    
    @objc func budgetChanged(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @IBAction func saveExpenseClicked(_ sender: Any) {
        guard let name = txtExpenseName.text else { return }
        guard let valueText = txtExpenseValue.text else { return }
        guard let value = HelperMethods.processValue(valueText) else { return }
        guard let category = txtCategory.text else { return }
        
        let params = ["expense_name" : name,
                      "expense_value" : value,
                      "created_at": Date(),
                      "category" : category] as [String : Any]
        
        FirebaseService.createNewExpense(params) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ExpenseCategories.categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ExpenseCategories.categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            self.txtCategory.text = ExpenseCategories.categoryList[row]
        }
    }
    
    
}
