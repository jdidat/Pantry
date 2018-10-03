//
//  ViewController.swift
//  Pantry
//
//  Created by Jackson Didat on 8/24/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Pastel
import ACFloatingTextfield_Objc

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email_address: ACFloatingTextField!
    @IBOutlet weak var password: ACFloatingTextField!
    
    weak var handle: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 7.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 252/255, green: 227/255, blue: 138/255, alpha: 1.0),
                              UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 245/255, green: 78/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 118/255, blue: 118/255, alpha: 1.0)//,
                              //UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              //UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              //UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)
            ])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

