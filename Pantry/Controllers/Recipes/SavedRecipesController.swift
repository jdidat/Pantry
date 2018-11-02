//
//  SavedRecipesController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import NightNight

class SavedRecipesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    var recipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
        self.refreshControl.beginRefreshing()
        getSaved { (err) in
            if err == nil {
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        if (NightNight.theme == .night) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            tableView.backgroundColor = UIColor.black
        }
        else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            tableView.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
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
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func deleteAction(at: IndexPath) -> UIContextualAction {
        let recipe = self.recipes[at.row]
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            APIManager.shared.deleteSavedRecipe(recipeName: recipe.title, completion: { (err) in
                if err == nil {
                    self.refreshControl.beginRefreshing()
                    self.getSaved { (err) in
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                    let alert = UIAlertController(title: "Deleted", message: "Recipe has been removed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    func getSaved(completion:@escaping(Error?)->()) {
        APIManager.shared.getSavedRecipes { (data, err) in
            if err != nil {
                completion(err)
            } else if let data = data {
                self.recipes = data
                completion(nil)
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getSaved { (err) in
            if err == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.refreshControl.endRefreshing()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselects cell after clicking on it
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "recipeDetailsSegue", sender: tableView.cellForRow(at: indexPath))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! RecipeCell
        let vc = segue.destination as! RecipeDetailsController
        vc.selectedRecipe = cell.recipe!
    }
}
