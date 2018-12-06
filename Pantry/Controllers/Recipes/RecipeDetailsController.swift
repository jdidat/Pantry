//
//  RecipeDetailsController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/3/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyButton
import NightNight
class RecipeDetailsController: UIViewController {
    
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    var selectedRecipe:Recipe?
    @IBOutlet weak var viewWebpageButton: FlatButton!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsDataLabel: UILabel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        if (NightNight.theme == .night) {
            self.view.backgroundColor = UIColor.black
            self.ingredientsLabel.textColor = UIColor.white
            self.ingredientsDataLabel.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            self.ingredientsLabel.textColor = UIColor.black
            self.ingredientsDataLabel.textColor = UIColor.black
        }
    }
    
    func contains(string: String, substring: String) -> Bool {
        return string.lowercased().range(of:substring.lowercased()) != nil
    }
    
    func generateIngredientsUI() {
        let object = UserDefaults.standard.object(forKey: "ingredients");
        if let recipe = selectedRecipe {
            let ingredientsArray = recipe.ingredients.components(separatedBy: ", ")
            var yPos = 325
            var counter = 1
            for string in ingredientsArray {
                let rect = CGRect(x: 40, y: yPos, width: 200, height: 21)
                let label = UILabel(frame: rect)
                label.text = "\(counter). \(string)"
                counter += 1
                if let object = object as? [String:[String:Any]] {
                    let keys = object.keys
                    for key in keys {
                        if contains(string: string, substring: key) {
                            label.textColor = UIColor.green
                            break
                        } else {
                            label.textColor = UIColor.red
                        }
                    }
                } else {
                    label.textColor = UIColor.red
                }
                self.view.addSubview(label)
                yPos = yPos+21;
            }
            recipeIngredients.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateIngredientsUI()
        if let url = URL(string: (selectedRecipe?.thumbnail)!) {
            let urlRequest = URLRequest(url: url)
            URLCache.shared.removeCachedResponse(for: urlRequest)
            Alamofire.request(url).responseImage { (response) in
                DispatchQueue.main.async {
                    self.recipeImage.image = response.value
                }
            }
        }
        if selectedRecipe?.href == nil || (selectedRecipe?.href.isEmpty)! {
            self.viewWebpageButton.isEnabled = false
        }
    }
    

    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            if let destinationVC = segue.destination as? WebViewController {
                if let url = URL(string: (selectedRecipe?.href)!) {
                    destinationVC.URL = url
                }
            }
        }
    }
    
}
