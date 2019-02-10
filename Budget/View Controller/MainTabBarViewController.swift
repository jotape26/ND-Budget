//
//  MainTabBarViewController.swift
//  Budget
//
//  Created by João Leite on 10/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addExpenseButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "AddExpenseViewController"))!, animated: true)
    }
    
    @IBAction func profileClicked(_ sender: Any) {
        let profileVC = storyboard!.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileVC, animated: true, completion: nil)
    }
    
    func configureScreen() {
        self.navigationController?.navigationBar.barTintColor = APPCOLOR.DARK_GREEN
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "VanguardCF-Bold", size: 27)!]
        self.navigationItem.leftBarButtonItem = profileButton
        self.navigationItem.rightBarButtonItem = addExpenseButton
        self.navigationItem.leftBarButtonItem?.tintColor = APPCOLOR.LIGHT_GREEN
        self.navigationItem.rightBarButtonItem?.tintColor = APPCOLOR.LIGHT_GREEN
    }
}
