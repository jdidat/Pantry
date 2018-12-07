//
//  EditCustomRecipeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 12/5/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import NightNight
import SwiftyButton

class EditCustomRecipeController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveChangesButton: FlatButton!
    
    var customRecipe: [String:Any] = [:]
    @IBAction func saveChanges(_ sender: UIButton) {
        APIManager.shared.editCustomRecipe(customRecipe: customRecipe, newRecipeName: titleTextField.text!, description: descriptionTextField.text!) { (error) in
            if error != nil {
                print(error)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        if (NightNight.theme == .night) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.view.backgroundColor = UIColor.black
            //titleLabel.textColor = UIColor.white
            //descriptionLabel.textColor = UIColor.white
        }
        else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.view.backgroundColor = UIColor.white
            //titleLabel.textColor = UIColor.black
            //descriptionLabel.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipeName = customRecipe["recipeName"] as? String {
            titleTextField.text! = recipeName
        }
        if let description = customRecipe["description"] as? String {
            descriptionTextField.text! = description
        }
        
        saveChangesButton.cornerRadius = 15
    }
}
