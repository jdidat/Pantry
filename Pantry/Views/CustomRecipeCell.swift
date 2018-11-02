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

extension UIColor {
    
    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
    
}


class CustomRecipeCell: UITableViewCell {
    
    @IBOutlet weak var customRecipeDescription: UILabel!
    @IBOutlet weak var customRecipeTitle: UILabel!
    @IBOutlet weak var customRecipeImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var customRecipeLikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var isLoading = false
    
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
                if self.likeButton != nil {
                    if let object = (UserDefaults.standard.string(forKey: (customRecipe["recipeName"] as! String) + (customRecipe["ownerId"] as! String))) {
                        if object == "liked"{
                            self.likeButton.setTitleColor(UIColor.green, for: .normal)
                            self.dislikeButton.setTitleColor(UIColor.systemBlue, for: .normal)
                        } else {
                            self.likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
                            self.dislikeButton.setTitleColor(UIColor.red, for: .normal)
                        }
                    } else {
                        self.likeButton.setTitleColor(UIColor.systemBlue, for: .normal)
                        self.dislikeButton.setTitleColor(UIColor.systemBlue, for: .normal)
                    }
                }
            }
        }
    }
    
    
    @IBAction func like(_ sender: Any) {
        if let customRecipe = customRecipe {
            let key = (customRecipe["recipeName"] as! String) + (customRecipe["ownerId"] as! String)
            if let object = UserDefaults.standard.string(forKey: key) {
                if object == "liked" && !isLoading {
                    isLoading = true
                    APIManager.shared.updateVotes(recipe: customRecipe, value: -1) { (err) in
                        if err != nil {
                            print("Didn't work")
                        } else {
                            UserDefaults.standard.removeObject(forKey: key)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                        }
                        self.isLoading = false
                    }
                } else if !isLoading {
                    isLoading = true
                    APIManager.shared.updateVotes(recipe: customRecipe, value: 2) { (err) in
                        if err != nil {
                            print("Didn't work")
                        } else {
                            UserDefaults.standard.set("liked", forKey: key)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                        }
                        self.isLoading = false
                    }
                }
            } else if !isLoading {
                isLoading = true
                APIManager.shared.updateVotes(recipe: customRecipe, value: 1) { (err) in
                    if err != nil {
                        print("Didn't work")
                    } else {
                        UserDefaults.standard.set("liked", forKey: key)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    @IBAction func dislike(_ sender: Any) {
        if let customRecipe = customRecipe {
            let key = (customRecipe["recipeName"] as! String) + (customRecipe["ownerId"] as! String)
            if let object = UserDefaults.standard.string(forKey: key) {
                if object == "disliked" && !isLoading {
                    isLoading = true
                    APIManager.shared.updateVotes(recipe: customRecipe, value: 1) { (err) in
                        if err != nil {
                            print("Didn't work")
                        } else {
                            print("HERE1")
                            UserDefaults.standard.removeObject(forKey: key)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                        }
                        self.isLoading = false
                    }
                } else if !isLoading {
                    isLoading = true
                    APIManager.shared.updateVotes(recipe: customRecipe, value: -2) { (err) in
                        if err != nil {
                            print("Didn't work")
                        } else {
                            print("HERE2")
                            UserDefaults.standard.set("disliked", forKey: key)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                        }
                        self.isLoading = false
                    }
                }
            } else if !isLoading {
                isLoading = true
                APIManager.shared.updateVotes(recipe: customRecipe, value: -1) { (err) in
                    if err != nil {
                        print("Didn't work")
                    } else {
                        print("HERE3")
                        UserDefaults.standard.set("disliked", forKey: key)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                    }
                    self.isLoading = false
                }
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
