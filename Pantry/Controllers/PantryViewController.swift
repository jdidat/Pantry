//
//  PantryViewController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class PantryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @IBOutlet weak var ingredientTitleInput: UITextField!
    
    var ingredients: [Ingredient] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Pantry"
        refreshControl.beginRefreshing()
        APIManager.shared.getIngredients { (data, err) in
            if let data = data {
                self.ingredients = data
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselects cell after clicking on it
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getIngredients { (data, err) in
            if let data = data {
                self.ingredients = data
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func addIngredient(_ sender: UIButton) {
        let ingredientTitle = ingredientTitleInput.text!
        if ingredientTitle.count == 0 {return}
        APIManager.shared.addIngredient(ingredient: Ingredient.init(title: ingredientTitle)) { (err) in
            if err != nil {
                print("Error adding ingredient")
            } else {
                let alert = UIAlertController(title: "Added", message: "Ingredient has been successfully added to pantry", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.ingredientTitleInput.text = ""
        }
    }
    
}
