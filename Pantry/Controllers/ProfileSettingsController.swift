//
//  ProfileSettingsViewController.swift
//  Pantry
//
//  Created by Joseph Davey on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
import NightNight
class ProfileSettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var darkModeButton: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x000000)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (NightNight.theme == .night) {
            darkModeButton.setOn(true, animated: true)
            darkModeButton.isSelected = true
            darkModeLabel.textColor = UIColor.white
        }
        else {
            darkModeButton.setOn(false, animated: true)
            darkModeButton.isSelected = false
            darkModeLabel.textColor = UIColor.black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func darkMode(_ sender: Any) {
        if (NightNight.theme == .night) {
            NightNight.theme = .normal
            darkModeLabel.textColor = UIColor.black
        }
        else {
            NightNight.theme = .night
            darkModeLabel.textColor = UIColor.white
        }
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
