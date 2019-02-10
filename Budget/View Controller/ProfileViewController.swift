//
//  ProfileViewController.swift
//  Budget
//
//  Created by João Leite on 09/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    let options = ["Edit Profile",
                   "Logout",
                   "Delete Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APPCOLOR.DARK_GREEN
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
        
        if let username = UserDefaults.standard.string(forKey: "userName") {
            lbUsername.text = username
        } else {
            lbUsername.text = ""
        }
        
        navigationController?.navigationBar.tintColor = UIColor.white
        closeBtn.imageView?.image!.withRenderingMode(.alwaysTemplate)
        closeBtn.imageView?.tintColor = UIColor.white
        
        downloadPhoto()
        
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadPhoto() {
        ImageService.downloadUserImage { (userImage) in
            DispatchQueue.main.async {
                self.userImage.image = userImage
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsCell")
        cell?.textLabel?.text = options[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            GIDSignIn.sharedInstance()?.disconnect()
        }
    }
    
    
}
