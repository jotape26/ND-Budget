//
//  FirebaseService.swift
//  Budget
//
//  Created by João Leite on 08/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseService {
    
    static func createDBInfo(_ userInfo: [String : Any]) {
        let db = Firestore.firestore()
        guard let userID = UserDefaults.standard.string(forKey: "userToken") else { return }
        db.collection("users").document(userID).setData(userInfo)
    }
    
    static func createNewExpense(_ expenseData: [String : Any],
                                 completion: @escaping ()->()) {
        let db = Firestore.firestore()
        guard let userID = UserDefaults.standard.string(forKey: "userToken") else { return }
        db.collection("users/\(userID)/expenses").addDocument(data: expenseData)
        completion()
    }
    
    
    static func retrieveUserExpenses(completion: @escaping([Expense])->()) {
        let db = Firestore.firestore()
        guard let userID = UserDefaults.standard.string(forKey: "userToken") else { return }
        db.collection("users").document(userID).collection("expenses").getDocuments { (snap, err) in
            if err !=  nil {
                print("fuck")
                return
            }
            
            if let snap = snap {
                var expensesList: [Expense] = []
                snap.documents.forEach({ (snap) in
                    let expense = Expense(JSON: snap.data())
                    if expense != nil {
                        expensesList.append(expense!)
                    }
                })
                
                expensesList.sort(){$0.expenseDate! > $1.expenseDate!}
                
                completion(expensesList)
            }
        }
    }
}
