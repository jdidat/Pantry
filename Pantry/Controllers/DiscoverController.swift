//
//  HomeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class HomeController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var searchURLBase = "http://www.recipepuppy.com/api/?q=steak"
    
    var recipies: [Recipe] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HERERER");
        var keywords = searchBar.text
        keywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURLBase = "http://www.recipepuppy.com/api/?q=\(keywords ?? "steak")"
        
        APIManager(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            print(self.recipies)
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
        cell.recipeImage.image = nil
        cell.recipe = recipies[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.title = "Discover"
        APIManager(urlString: searchURLBase) { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            print(self.recipies)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
}
