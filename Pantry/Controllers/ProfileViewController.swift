//
//  ProfileViewController.swift
//  Pantry
//
//  Created by Joseph Davey on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
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
            } else {
                print(err!.localizedDescription)
            }
        })
        //Make Profile Picture Circular
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
