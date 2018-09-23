//
//  ViewController.swift
//  Pantry
//
//  Created by Jackson Didat on 8/24/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

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
        Auth.auth().createUser(withEmail: email_address.text!, password: password.text!, completion: { (result, error) -> Void in
            if (error == nil) {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
        });
    }
    
}

