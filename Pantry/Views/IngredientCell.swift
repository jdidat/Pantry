//
//  TableViewCell.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/28/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientTitle: UILabel!
    @IBOutlet weak var ingredientCounter: UILabel!
    
    var ingredientCount: Int = 0
    
    var ingredient: Ingredient? {
        didSet {
            ingredientTitle.text = ingredient?.title
            ingredientCounter.text = String(ingredient!.count)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func decrease(_ sender: UIButton) {
        if (ingredientCount < 1) {return}
        ingredient?.decrement()
        ingredientCounter.text = String(ingredient!.count)
    }
    
    @IBAction func increase(_ sender: UIButton) {
        if (ingredientCount >= 100) {return}
        ingredient?.increment()
        ingredientCounter.text = String(ingredient!.count)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
