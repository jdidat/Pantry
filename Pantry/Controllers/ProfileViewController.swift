//
//  ProfileViewController.swift
//  Pantry
//
//  Created by Joseph Davey on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var recipeNumber: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.shared.getCurrentUserData(completion: { (data, err) in
            if let data = data {
                self.username.text! = data["username"] as! String
                self.ratingNumber.text! = String(describing: data["rating"] as! Double)
                self.recipeNumber.text! = String(describing: data["recipeCount"] as! Int)
                if let url = URL(string: data["profileImageURL"] as! String) {
                    let urlRequest = URLRequest(url: url)
                    URLCache.shared.removeCachedResponse(for: urlRequest)
                    Alamofire.request(url).responseImage { (response) in
                        DispatchQueue.main.async {
                            self.profilePicture.image = response.value
                        }
                    }
                }
            } else {
                print(err!.localizedDescription)
            }
        })
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //Make Profile Picture Circular
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        profilePicture.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
        
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
            profilePicture.image = image
            let data = UIImageJPEGRepresentation(image, 0.5)
            if let user = Auth.auth().currentUser {
                APIManager.shared.uploadImage(image: data!, path: "images/\(user.uid)/profile", completion: { (error, url) in
                    if error == nil && url != nil {
                        APIManager.shared.updateUserEntry(entry: "profileURL", value: String(describing: url!), completion: { (err) in
                            if err == nil {
                                let alert = UIAlertController(title: "Saved", message: "Profile image has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
