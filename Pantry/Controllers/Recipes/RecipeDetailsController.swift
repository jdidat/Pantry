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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = selectedRecipe {
            recipeIngredients.text = recipe.ingredients
        }
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
