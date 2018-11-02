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
    
    @IBOutlet weak var ingredientTitleInput: UITextField!
    
    var ingredients: [String:Ingredient] = [:]
    var initialState: [String:Ingredient] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Pantry"
        if let object = UserDefaults.standard.object(forKey: "ingredients") {
            for(key, value) in object as! [String:[String:Any]]{
                self.ingredients[key] = Ingredient(dictionary: value)
                self.initialState[key] = Ingredient(dictionary: value)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if initialState != ingredients {
            let alert = UIAlertController(title: "Save?", message: "You have made changes to your endgredients do you want to save?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                var serializedData:[String:[String:Any]] = [:]
                for(key, value) in self.ingredients {
                    serializedData[key] = ["title": value.title, "count": value.count]
                }
                UserDefaults.standard.set(serializedData, forKey: "ingredients")
                self.initialState = self.ingredients
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredient = Array(ingredients)[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselects cell after clicking on it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func deleteAction(at: IndexPath)  -> UIContextualAction {
        let ingredientKey = Array(self.ingredients)[at.row].key
        let action = UIContextualAction(style: .normal, title: "Remove") { (action, view, completion) in
            self.ingredients.removeValue(forKey: ingredientKey)
            self.tableView.reloadData()
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    @IBAction func addIngredient(_ sender: UIButton) {
        let ingredientTitle = ingredientTitleInput.text!
        if ingredientTitle.count == 0 {return}
        if self.ingredients[ingredientTitle] != nil {
            let alert = UIAlertController(title: "Error", message: "That ingredient already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let currentIngredient = Ingredient.init(dictionary: ["title": ingredientTitle, "count": 1])
        self.ingredients[ingredientTitle] = currentIngredient
        self.tableView.reloadData()
        self.ingredientTitleInput.text = ""
    }
    
}
