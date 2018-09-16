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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func create_account(_ sender: Any) {
        Auth.auth().createUser(withEmail: email_address.text!, password: password.text!)
    }
    
}

