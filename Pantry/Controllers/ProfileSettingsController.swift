//
//  ProfileSettingsViewController.swift
//  Pantry
//
//  Created by Joseph Davey on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let lvc = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController = lvc
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
