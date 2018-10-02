//
//  ViewController.swift
//  Pantry
//
//  Created by Jackson Didat on 8/24/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email_address: UITextField!
    @IBOutlet weak var password: UITextField!
    
    weak var handle: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func create_account(_ sender: Any) {
        APIManager.shared.createUser(email: email_address.text!, password: password.text!, username: "Test") { (error) in
            if (error == nil) {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        APIManager.shared.loginUser(email: email_address.text!, password: password.text!) { (error) in
            if error == nil {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

