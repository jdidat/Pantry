//
//  HomeController.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class HomeController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var recipies: [Recipe] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
        cell.recipe = recipies[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        APIManager(urlString: "http://www.recipepuppy.com/api/?q=steak") { (searchResults: RecipeSearch) in
            let recipies = searchResults.results
            self.recipies = recipies
            print(self.recipies)
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
}
