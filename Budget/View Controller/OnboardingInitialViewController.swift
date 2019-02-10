//
//  OnboardingInitialViewController.swift
//  Budget
//
//  Created by João Leite on 08/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import GoogleSignIn

class OnboardingInitialViewController: UIViewController, GIDSignInUIDelegate{
    
    @IBOutlet weak var logoConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var lbFriend: UILabel!
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton!
    @IBOutlet weak var lbAccess: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoConstraint.constant = 0
        self.optionsView.alpha = 0
        self.lbFriend.alpha = 0
        self.lbAccess.alpha = 0
        self.btnGoogleLogin.alpha = 0        
        
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        optionsView.layer.cornerRadius = 6
        btnGoogleLogin.colorScheme = .light
        btnGoogleLogin.style = .wide
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.logoConstraint.constant = -150.0
           
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.optionsView.alpha = 0.3
                self.lbFriend.alpha = 1
                self.lbAccess.alpha = 1
                self.btnGoogleLogin.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
    }
}
