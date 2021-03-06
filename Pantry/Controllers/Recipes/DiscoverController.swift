//
//  HomeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import TableFlip
import NightNight
import SwiftyButton
class DiscoverController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var ingredientSearchButton: FlatButton!
    
    var searchURLBase = "http://www.recipepuppy.com/api/?q=steak"
    var searchURLWithIngredients = ""
    var recipies: [Recipe] = []
    var searchWithIngredients = false
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var keywords = searchBar.text
        keywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        
        searchURLBase = "http://www.recipepuppy.com/api/?q=\(keywords ?? "steak")"
        
        if searchWithIngredients {
            searchURLBase += "&" + searchURLWithIngredients
        }
        
        print(searchURLBase)
        
        APIManager.shared.get(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            recipies = []
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
            }
            return;
        }
        searchURLBase = "http://www.recipepuppy.com/api/?q=\(searchText)"
        
        if searchWithIngredients {
            searchURLBase += "&" + searchURLWithIngredients
        }
        APIManager.shared.get(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselects cell after clicking on it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.cornerRadius = 20
        cell.cardView.clipsToBounds = true
        cell.recipeImage.image = UIImage(named: "default")
        cell.recipeImage.layer.borderWidth = 1
        cell.recipeImage.layer.masksToBounds = false
        cell.recipeImage.layer.borderColor = UIColor.black.cgColor
        cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.height/2
        cell.recipeImage.clipsToBounds = true
        cell.recipe = recipies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [like])
    }
    
    
    func likeAction(at: IndexPath) -> UIContextualAction {
        let recipe = self.recipies[at.row]
        let action = UIContextualAction(style: .normal, title: "Save") { (action, view, completion) in
            let alert = UIAlertController(title: "Saved", message: "Recipe has been saved for later use", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            APIManager.shared.saveRecipe(recipe: recipe, completion: { (err) in
                if err == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
        action.backgroundColor = UIColor.green
        return action
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        if (NightNight.theme == .night) {
            table.backgroundColor = UIColor.black
            searchBar.backgroundColor = UIColor.black
            textField?.textColor = UIColor.white
        }
        else {
            table.backgroundColor = UIColor.white
            searchBar.backgroundColor = UIColor.white
            textField?.textColor = UIColor.black
        }
        APIManager.shared.get(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.animate(animation: TableViewAnimation.Cell.left(duration: 0.5))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        if (NightNight.theme == .night) {
            table.backgroundColor = UIColor.black
            searchBar.backgroundColor = UIColor.black
            textField?.textColor = UIColor.white
        }
        else {
            table.backgroundColor = UIColor.white
            searchBar.backgroundColor = UIColor.white
            textField?.textColor = UIColor.black
        }
        var url = "i="
        
        if let object = UserDefaults.standard.object(forKey: "ingredients") {
            var count: Int = 0
            for(key, _) in object as! [String:[String:Any]]{
                url += key + ","
                count+=1
            }
            if count == 0 {
                return
            }
            self.searchURLWithIngredients = url
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! RecipeCell
        let vc = segue.destination as! RecipeDetailsController
        vc.selectedRecipe = cell.recipe!
    }
    
    @IBAction func searchByIngredients(_ sender: Any) {
        self.searchWithIngredients = !self.searchWithIngredients
        if self.searchWithIngredients {
            self.ingredientSearchButton.setTitle("Ingredient Search (ON)", for: .normal)
        } else {
            self.ingredientSearchButton.setTitle("Ingredient Search (OFF)", for: .normal)
        }
    }
    
    
}
