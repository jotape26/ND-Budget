//
//  AppDelegate.swift
//  Budget
//
//  Created by João Leite on 05/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var loggedUser: GIDGoogleUser?
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let newFont = UIFont(name: "Hiragino Sans W3", size: 17.0)!
        let color = UIColor.white
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([.foregroundColor: color, .font: newFont], for: .normal)
        
        if defaults.value(forKey: "loginCompleted") as? Bool == true {
            if defaults.value(forKey: "profileCompleted") as? Bool == true {
                 goToHome()
            } else {
                goToBuildProfile()
            }
        } else {
            defaults.set(false, forKey: "loginCompleted")
            defaults.set(false, forKey: "profileCompleted")
            backToOnboarding()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                          accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                print("fuck")
                return
            }
            if let auth = authResult {
                
                if let profile = user.profile {
                    self.defaults.set(profile.name, forKey: "userName")
                    self.defaults.set(profile.email, forKey: "userEmail")
                    self.defaults.set(profile.imageURL(withDimension: 100)?.absoluteString, forKey: "userImage")
                    self.defaults.set(auth.user.uid, forKey: "userToken")
                    
                    let userInfo = ["userName" : user.profile.name,
                                    "userEmail" : user.profile.email,
                                    "registryDate" : Date()] as [String : Any]
                    
                    FirebaseService.createDBInfo(userInfo)
                    
                    print("\(user.profile.name!) logged in.")
                    self.defaults.set(true, forKey: "loginCompleted")
                    self.goToBuildProfile()
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        defaults.removeObject(forKey: "userName")
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userImage")
        defaults.removeObject(forKey: "userToken")
        
        backToOnboarding()
    }
    
    func backToOnboarding() {
        
        let onboardingSB = UIStoryboard(name: "Onboarding", bundle: nil)
        let initialVC = onboardingSB.instantiateInitialViewController()
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.window?.rootViewController = initialVC
        }, completion: nil)
    }
    
    func goToHome() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = homeSB.instantiateInitialViewController()
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = initialVC
        }, completion: nil)
    }
    
    func goToBuildProfile() {
        let homeSB = UIStoryboard(name: "Onboarding", bundle: nil)
        let profileVC = homeSB.instantiateViewController(withIdentifier: "BuildProfileViewController")
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = profileVC
        }, completion: nil)
    }
}

