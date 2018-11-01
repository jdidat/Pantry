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

class RecipeDetailsController: UIViewController {
    
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    var selectedRecipe:Recipe?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
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
