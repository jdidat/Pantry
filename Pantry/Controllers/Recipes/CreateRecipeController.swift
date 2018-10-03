//
//  CreateRecipeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/3/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class CreateRecipeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDescriptionField: UITextField!
    @IBOutlet weak var recipeNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        recipeImage.isUserInteractionEnabled = true
        recipeImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createRecipe(_ sender: UIButton) {
        let recipeName = recipeNameField.text!
        let recipeDescription = recipeDescriptionField.text!
        if checkTextFields() {
            APIManager.shared.createCustomRecipe(recipeName: recipeName, description: recipeDescription, image: recipeImage.image) { (err) in
                if err != nil {
                    let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                    
                    self.dismiss(animated: true, completion: nil)
                }
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
            recipeImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkTextFields() -> Bool {
        if (recipeNameField.text?.count)! > 3 && (recipeDescriptionField.text?.count)! < 140 {
            return true
        }
        return false
    }
}
