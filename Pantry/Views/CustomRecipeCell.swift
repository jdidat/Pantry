//
//  CustomRecipeCell.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class CustomRecipeCell: UITableViewCell {

    @IBOutlet weak var customRecipeDescription: UILabel!
    @IBOutlet weak var customRecipeTitle: UILabel!
    @IBOutlet weak var customRecipeImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var customRecipeLikes: UILabel!
    
    var customRecipe: [String:Any]? {
        didSet {
            if let customRecipe = customRecipe {
                customRecipeTitle.text = customRecipe["recipeName"] as? String
                customRecipeDescription.text = customRecipe["description"] as? String
                if let customLikes = customRecipe["likes"] as? Int {
                    customRecipeLikes.text = String(customLikes)
                }
                if let urlString = customRecipe["imageURL"] as? String {
                    if let url = URL(string: urlString) {
                        let urlRequest = URLRequest(url: url)
                        URLCache.shared.removeCachedResponse(for: urlRequest)
                        Alamofire.request(url).responseImage { (response) in
                            DispatchQueue.main.async {
                                self.customRecipeImage.image = response.value
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func like(_ sender: Any) {
        print("like")
    }
    
    @IBAction func dislike(_ sender: Any) {
        print("dislike")
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
