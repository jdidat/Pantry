//
//  HomeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class DiscoverController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var searchURLBase = "http://www.recipepuppy.com/api/?q=steak"
    var recipies: [Recipe] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var keywords = searchBar.text
        keywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURLBase = "http://www.recipepuppy.com/api/?q=\(keywords ?? "steak")"
        
        APIManager.shared.get(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipeImage.image = UIImage(named: "default")
        cell.recipe = recipies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [like])
    }
    
    func likeAction(at: IndexPath) -> UIContextualAction {
        let recipe = self.recipies[at.row]
        let action = UIContextualAction(style: .normal, title: "Like") { (action, view, completion) in
            let alert = UIAlertController(title: "Saved", message: "Recipe has been saved for later use", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completion(true)
        }
        action.backgroundColor = UIColor.green
        return action
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! RecipeCell
        let vc = segue.destination as! RecipeDetailsController
        vc.selectedRecipe = cell.recipe!
    }
}
