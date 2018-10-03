//
//  RecipeDetailsController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/3/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class RecipeDetailsController: UIViewController {

    var selectedRecipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
