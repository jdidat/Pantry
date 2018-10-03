//
//  CustomRecipeCell.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class CustomRecipeCell: UITableViewCell {

    @IBOutlet weak var customRecipeDescription: UILabel!
    @IBOutlet weak var customRecipeTitle: UILabel!
    @IBOutlet weak var customRecipeImage: UIImageView!
    
    var customRecipe: [String:Any]? {
        didSet {
            if let customRecipe = customRecipe {
                customRecipeTitle.text = customRecipe["recipeName"] as? String
                customRecipeDescription.text = customRecipe["description"] as? String
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
