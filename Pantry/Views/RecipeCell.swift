//
//  RecipeCell.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipieIngredients: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    
    var recipe: Recipe? {
        didSet {
            recipeTitle.text = recipe?.title
            if let url = URL(string: (recipe?.thumbnail)!) {
                let urlRequest = URLRequest(url: url)
                URLCache.shared.removeCachedResponse(for: urlRequest)
                Alamofire.request(url).responseImage { (response) in
                    DispatchQueue.main.async {
                        self.recipeImage.image = response.value
                    }
                }
            }
            recipieIngredients.text = recipe?.ingredients
        }
    }
}
