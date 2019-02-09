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
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addExpenseButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var budgetHeight: NSLayoutConstraint!
    @IBOutlet weak var budgetLabel: UILabel!
    
    var expenses: [Expense] = []
    var test = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureScreen()
        
        expensesTable.register(UINib(nibName: "ExpensesCell", bundle: nil), forCellReuseIdentifier: "ExpensesCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getExpenses()
    }
    
    @IBAction func addExpenseClicked(_ sender: Any) {
        performSegue(withIdentifier: "MainToAddSegue", sender: nil)
    }
}

//MARK: - Custom Functions
extension ExpensesHomeViewController {
    
    func configureScreen() {
        self.navigationController?.navigationBar.barTintColor = APPCOLOR.DARK_GREEN
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "VanguardCF-Bold", size: 21)!]
        self.headerView.backgroundColor = APPCOLOR.DARK_GREEN
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = addExpenseButton
        self.navigationItem.leftBarButtonItem?.tintColor = APPCOLOR.LIGHT_GREEN
        self.navigationItem.rightBarButtonItem?.tintColor = APPCOLOR.LIGHT_GREEN
    }
    
    func getExpenses() {
        
        FirebaseService.retrieveUserExpenses { (retrievedExpenses) in
            self.expenses = retrievedExpenses
            
            self.expenses.forEach({ (t) in
                self.test = self.test + t.expenseValue!
            })
            
            self.lbBudget.text = "\(self.test)"
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            if self.test > 2000.0 {
                UIView.animate(withDuration: 1.5, animations: {
                    self.budgetHeight.constant = 30
                    self.budgetLabel.backgroundColor = APPCOLOR.ORANGE
                })
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
        cell.lbExpenseValue.text = expenses[indexPath.row].expenseValue?.description
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        if let expense = expenses[indexPath.row].expenseDate {
            cell.lbDateExpense.text = df.string(from: expense)
        } else {
            cell.lbDateExpense.text = ""
        }
        
        return cell
    }
    
}

