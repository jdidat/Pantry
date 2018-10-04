//
//  CreateAccountViewController.swift
//  Pantry
//
//  Created by Jackson Didat on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Pastel
import ACFloatingTextfield_Objc
class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameText: ACFloatingTextField!
    @IBOutlet weak var emailText: ACFloatingTextField!
    @IBOutlet weak var passwordText: ACFloatingTextField!
    @IBOutlet weak var confirmPassword: ACFloatingTextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
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
    }

    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if let password = passwordText.text {
            if let confirmPassword = confirmPassword.text {
                if password != confirmPassword {
                    let alert = UIAlertController(title: "Wrong Password", message: "The passwords do not match", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return;
                }
            }
        }
        guard let usernameText = usernameText.text else {return;}
        APIManager.shared.createUser(email: emailText.text!, password: passwordText.text!, username: usernameText, image: profileImage.image) { (error) in
            if (error == nil) {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Wrong Password", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
