//
//  CreateAccountViewController.swift
//  Pantry
//
//  Created by Jackson Didat on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        profileImage.isUserInteractionEnabled = true
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
//        profileImage.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailText.text!, password: emailText.text!, completion: { (result, error) ->
            Void in
            if (error == nil) {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
        })
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = selectedPhoto
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
