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
    var expenses: [Expense] = []
    var test = 0.0
    
    fileprivate var profileButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "profile"), style: UIBarButtonItem.Style.done, target: self, action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureScreen()
        getExpenses()
        
        expensesTable.register(UINib(nibName: "ExpensesCell", bundle: nil), forCellReuseIdentifier: "ExpensesCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
    }
    @IBAction func slkaf(_ sender: Any) {
        GIDSignIn.sharedInstance()?.disconnect()        
//        let onboardingVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
//        
//        present(onboardingVC!, animated: true, completion: nil)
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
        self.navigationItem.leftBarButtonItem?.tintColor = APPCOLOR.LIGHT_GREEN
    }
    
    func getExpenses() {
            
            DispatchQueue.main.async {
                self.lbBudget.text = "You've spent \(self.test.description) this month"
                
                if self.test > 1000.0 {
                    DispatchQueue.main.async {
                        self.headerView.backgroundColor = APPCOLOR.ORANGE
                        self.navigationController?.navigationBar.barTintColor = APPCOLOR.ORANGE
                    }
                }
                self.expensesTable.reloadData()
        }
        
    }
}

extension ExpensesHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
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

