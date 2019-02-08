//
//  ExpensesHomeViewController.swift
//  Budget
//
//  Created by João Leite on 05/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ExpensesHomeViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var expensesTable: UITableView!
    @IBOutlet weak var lbBudget: UILabel!
    var db: Firestore?
    var expenses: [Expense] = []
    var test = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = Firestore.firestore()
        configureScreen()
        getExpenses()
        
        expensesTable.register(UINib(nibName: "ExpensesCell", bundle: nil), forCellReuseIdentifier: "ExpensesCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
    }
    
}

//MARK: - Custom Functions
extension ExpensesHomeViewController {
    
    func configureScreen() {
        self.navigationController?.navigationBar.barTintColor = APPCOLOR.DARK_GREEN
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.init(name: "Noteworthy", size: 26)!]
        self.headerView.backgroundColor = APPCOLOR.DARK_GREEN
    }
    
    func getExpenses() {
        guard let db = db else { return }
        
        db.collection("users").document("jotape26").collection("expenses").getDocuments { (snap, err) in
            if err !=  nil {
                print("fuck")
                return
            }
            
            if let snap = snap {
                snap.documents.forEach({ (snap) in
                    let expense = Expense(JSON: snap.data())
                    if let expense = expense {
                        
                        if let date = expense.expenseDate {
                            if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month){
                                self.test = self.test + expense.expenseValue!
                            }
                        }
                        
                        
                        self.expenses.append(expense)
                    }
                })
            }
            
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

