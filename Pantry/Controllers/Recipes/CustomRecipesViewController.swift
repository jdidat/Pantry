//
//  CustomRecipesViewController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import NightNight

class CustomRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet var myView: UIView!
    
    var customRecipes : [String: [String:Any]] = [:]
    var allRecipies : [String: [String:Any]] = [:]
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keywords = searchText.lowercased()
        if allRecipies[keywords] != nil {
            customRecipes[keywords] = allRecipies[keywords]
        } else {
            customRecipes = [:]
        }
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        self.searchBar.delegate = self
        
        self.table.addSubview(self.refreshControl)
        self.refreshControl.beginRefreshing()
        APIManager.shared.getAllCustomRecipes { (recipes, err) in
            if err != nil {
                print("Error loading")
            }
            else {
                self.allRecipies = recipes!
                self.table.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if NightNight.theme == .night {
            table.backgroundColor = UIColor.black
            myView.backgroundColor = UIColor.black
            table.backgroundColor = UIColor.black
        }
        else {
            table.backgroundColor = UIColor.white
            myView.backgroundColor = UIColor.white
            table.backgroundColor = UIColor.white
        }
    }
    
    /* Table code start */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRecipeCell", for: indexPath) as! CustomRecipeCell
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.cornerRadius = 20
        cell.cardView.clipsToBounds = true
        cell.customRecipeImage.image = UIImage(named: "default")
        cell.customRecipeImage.layer.borderWidth = 1
        cell.customRecipeImage.layer.masksToBounds = false
        cell.customRecipeImage.layer.borderColor = UIColor.black.cgColor
        cell.customRecipeImage.layer.cornerRadius = cell.customRecipeImage.frame.height/2
        cell.customRecipeImage.clipsToBounds = true
        cell.customRecipe = Array(customRecipes)[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func deleteAction(at: IndexPath) -> UIContextualAction {
        let recipe = Array(customRecipes)[at.row].value
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            if let recipeName = recipe["recipeName"] as? String {
                APIManager.shared.deleteCutomRecipe(recipeName: recipeName, completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "Deleted", message: "Recipe has been deleted", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.getRecipies { (err) in
                            if let err = err {
                                print(err.localizedDescription)
                            } else {
                                DispatchQueue.main.async {
                                    self.table.reloadData()
                                }
                            }
                        }
                    }
                    completion(true)
                })
            }
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    
    /*Table code end*/
    
    func getRecipies(completion: @escaping (Error?)->()){
        
    }
    
}
