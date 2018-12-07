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
import SwiftyButton
import ACFloatingTextfield_Objc

class ProfileSettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var darkModeButton: UISwitch!
    @IBOutlet weak var newPassword: ACFloatingTextField!
    @IBOutlet weak var confirmNewPassword: ACFloatingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x000000)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
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
    
    @IBAction func updatePassword(_ sender: FlatButton) {
        if !checkPassword() {
            let alert = UIAlertController(title: "Error", message: "The passwords do not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let user = APIManager.shared.currentUser {
                user.updatePassword(to: newPassword.text!) { (error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Success", message: "Password is now updated", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func deleteAccountPrompt(_ sender: FlatButton) {
        let alert = UIAlertController(title: "Delete account", message: "Are you sure want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            Auth.auth().currentUser?.delete(completion: { (error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let lvc = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
                    UIApplication.shared.keyWindow?.rootViewController = lvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            do {
                try Auth.auth().signOut()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let lvc = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = lvc
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    
    func checkPassword() ->  Bool {
        if let password = newPassword.text {
            if let confirmPassword = confirmNewPassword.text {
                if password != confirmPassword {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
}
