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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipeImage: UIImageView!
    var selectedRecipe:Recipe?
    @IBOutlet weak var viewWebpageButton: FlatButton!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    var totalIngredientsHeight:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        if (NightNight.theme == .night) {
            self.view.backgroundColor = UIColor.black
            self.ingredientsLabel.textColor = UIColor.white
            self.recipeTitle.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            self.ingredientsLabel.textColor = UIColor.black
            self.recipeTitle.textColor = UIColor.black
        }
    }
    
    func contains(string: String, substring: String) -> Bool {
        return string.lowercased().range(of:substring.lowercased()) != nil
    }
    
    
    
    
    func generateIngredientsUI() {
        let object = UserDefaults.standard.object(forKey: "ingredients");
        if let recipe = selectedRecipe {
            let ingredientsArray = recipe.ingredients.components(separatedBy: ", ")
            var yPos = self.ingredientsLabel.frame.origin.y + self.ingredientsLabel.frame.height + 24
            var counter = 1
            let height = 30
            
            for string in ingredientsArray {
                let rect = CGRect(x: 40, y: Int(yPos), width: 300, height: height)
                let label = UILabel(frame: rect)
                label.text = "\(counter). \(string)"
                label.font = label.font.withSize(20)
                label.numberOfLines = 0
                label.sizeToFit()
                counter += 1
                if let object = object as? [String:[String:Any]] {
                    let keys = object.keys
                    for key in keys {
                        if contains(string: string, substring: key) {
                            
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.white, range: NSMakeRange(0, attributeString.length))
                            label.attributedText = attributeString
                            label.textColor = UIColor(hue: 142/360, saturation: 100/100, brightness: 70/100, alpha: 1.0) /* #00b241 */
                            break
                        } else {
                            label.textColor = UIColor.red
                        }
                    }
                } else {
                    label.textColor = UIColor.red
                }
                self.scrollView.addSubview(label)
                yPos = yPos+CGFloat(label.frame.height + 8);
            }
            totalIngredientsHeight = Int(yPos)
        }
    }
    
    func generateDirections(directions: [String]){
        var yPos = totalIngredientsHeight + 20
        var counter = 1
        let height = 30
        DispatchQueue.main.async() {
            let rect = CGRect(x: 16, y: Int(yPos), width: 300, height: height)
            let label = UILabel(frame: rect)
            label.font = label.font.withSize(30)
            label.text = "Directions"
            if (NightNight.theme == .night) {
                label.textColor = UIColor.white
            }
            else {
                label.textColor = UIColor.black
            }
            self.scrollView.addSubview(label)
            yPos += Int(label.frame.height) + 8;
        }
        for string in directions {
            DispatchQueue.main.async() {
                let rect = CGRect(x: 40, y: Int(yPos), width: 300, height: height)
                let label = UILabel(frame: rect)
                label.text = "\(counter). \(string)"
                label.font = label.font.withSize(20)
                if (NightNight.theme == .night) {
                    label.textColor = UIColor.white
                }
                else {
                    label.textColor = UIColor.black
                }
                label.numberOfLines = 0
                label.sizeToFit()
                counter += 1
                self.scrollView.addSubview(label)
                yPos = yPos+Int(label.frame.height) + 8;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
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
        self.recipeTitle.text = selectedRecipe?.title
        var url = selectedRecipe?.href.components(separatedBy: "/")
        let token = url![(url?.count)! - 1];
        APIManager.shared.getDirections(urlString: "https://pantry-parser.herokuapp.com/recipe/\(token)") { (data, err) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let directions = dictionary["directions"] as? [String] {
                        self.generateDirections(directions: directions)
                    }
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
