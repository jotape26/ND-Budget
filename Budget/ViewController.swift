//
//  ViewController.swift
//  Budget
//
//  Created by João Leite on 05/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = Firestore.firestore()
    }
    
    @IBAction func salvarBtnClicked(_ sender: Any) {
        
        guard let db = db else { return }
        
        var ref: DocumentReference? = nil
        ref = db.collection("expenses").addDocument(data: [
            "name": "Compra Mac Mini",
            "date": Date().description,
            "value": 7500.50,
            "map": ["test":"test"]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        db.collection("expenses").
            
        
    }
    
}

