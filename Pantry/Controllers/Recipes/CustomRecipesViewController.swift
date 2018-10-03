//
//  CustomRecipesViewController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class CustomRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var customRecipes : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        APIManager.shared.getCustomRecipes { (customRecipes: [[String:Any]]?, err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                self.customRecipes = customRecipes!
                print(self.customRecipes)
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRecipeCell", for: indexPath) as! CustomRecipeCell
        cell.customRecipeImage.image = UIImage(named: "default")
        cell.customRecipe = customRecipes[indexPath.row]
        return cell
    }
    

    @IBAction func addRecipe(_ sender: UIButton) {
        APIManager.shared.createCustomRecipe(recipeName: "Cheese String", description: "Jackson's favorite") { (err) in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Success", message: "Saved custom recipe!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
