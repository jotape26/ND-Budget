//
//  ExpensesHomeViewController.swift
//  Budget
//
//  Created by João Leite on 05/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleSignIn

class ExpensesHomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var expensesTable: UITableView!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var budgetHeight: NSLayoutConstraint!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var smileyImage: UIImageView!
    let form = NumberFormatter()
    
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        expensesTable.register(UINib(nibName: "ExpensesCell", bundle: nil), forCellReuseIdentifier: "ExpensesCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
        
        headerView.backgroundColor = APPCOLOR.DARK_GREEN
        form.numberStyle = .currencyAccounting
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        lbBudget.text = ""
        activityIndicator.startAnimating()
        getExpenses()
    }
}

//MARK: - Custom Functions
extension ExpensesHomeViewController {
    
    func getExpenses() {
        
        FirebaseService.retrieveUserExpenses { (retrievedExpenses) in
            self.expenses = retrievedExpenses
            if !self.expenses.isEmpty {
                self.smileyImage.isHidden = true
            }
            
            var monthlyExpenses = 0.0
            
            self.expenses.forEach({ (t) in
                if Calendar.current.isDate(t.expenseDate!, equalTo: Date(), toGranularity: .month){
                    monthlyExpenses = monthlyExpenses + t.expenseValue!
                }
            })
            
            let formattetExpense = self.form.string(from: monthlyExpenses as NSNumber)!
            
            self.lbBudget.text = "You've spent \(formattetExpense) this month."
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            if let userBudget = UserDefaults.standard.value(forKey: "userBudget") as? Double {
                if monthlyExpenses > userBudget {
                    UIView.animate(withDuration: 1.5, animations: {
                        self.budgetHeight.constant = 30
                        self.budgetLabel.backgroundColor = APPCOLOR.ORANGE
                    })
                }
            }
            
            self.expensesTable.reloadData()
        }
    }
}

extension ExpensesHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.expenses.count)
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesCell") as! ExpensesCell
        
        cell.lbExpenseName.text = expenses[indexPath.row].expenseName
        
        
        cell.lbExpenseValue.text = form.string(from: expenses[indexPath.row].expenseValue! as NSNumber)
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        if let expense = expenses[indexPath.row].expenseDate {
            cell.lbDateExpense.text = df.string(from: expense)
        } else {
            cell.lbDateExpense.text = ""
        }
        
        if let category = expenses [indexPath.row].category {
            cell.expenseText.text = category
        }
        
        return cell
    }
    
}

