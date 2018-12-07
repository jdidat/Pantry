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
    
    var likesAsc:Bool = false
    var viewsAsc:Bool = false
    
    var searchItem: String = ""
    
    var customRecipes : [[String:Any]] = []
    var allRecipies : [[String:Any]] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keywords = searchText.lowercased()
        self.searchItem = keywords
        updateTable(keywords: self.searchItem)
    }
    

    
    func updateTable(keywords: String) {
        self.customRecipes = []
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        var count = 0
        for (value) in self.allRecipies {
            let key = value["recipeName"] as! String
            if key.contains(keywords) {
                self.customRecipes.append(value)
                count += 1
            }
        }
        if count == 0 {
            self.customRecipes = []
        }
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.addSubview(refreshControl)
        self.searchBar.delegate = self
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
        APIManager.shared.getAllCustomRecipes { (recipes, err) in
            if err != nil {
                print("Error loading")
            }
            else {
                self.allRecipies = recipes!
                self.table.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(CustomRecipesViewController.refreshTable), name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }
    
    @objc
    func refreshTable() {
        self.getRecipies { (err) in
            if err == nil {
                self.updateTable(keywords: self.searchItem)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APIManager.shared.getAllCustomRecipes { (recipes, err) in
            if err != nil {
                print("Error loading")
            }
            else {
                self.allRecipies = recipes!
                self.table.reloadData()
            }
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
        cell.cardView.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.cornerRadius = 20
        cell.cardView.clipsToBounds = true
        cell.customRecipeImage.image = UIImage(named: "default")
        cell.customRecipeImage.layer.borderWidth = 1
        cell.customRecipeImage.layer.masksToBounds = false
        cell.customRecipeImage.layer.borderColor = UIColor.black.cgColor
        cell.customRecipeImage.layer.cornerRadius = cell.customRecipeImage.frame.height/2
        cell.customRecipeImage.clipsToBounds = true
        cell.customRecipe = customRecipes[indexPath.row]
        if customRecipes[indexPath.row]["ownerId"] as! String == APIManager.shared.currentUserId {
            cell.cardView.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [like])
    }
    
    func likeAction(at: IndexPath) -> UIContextualAction {
        var recipe = self.customRecipes[at.row]
        recipe["title"] = recipe["recipeName"]
        if let imageURL = recipe["imageURL"] as? String {
            recipe["thumbnail"] = imageURL
        }
        recipe["ingredients"] = recipe["description"]
        recipe["href"] = ""
        let action = UIContextualAction(style: .normal, title: "Save") { (action, view, completion) in
            let alert = UIAlertController(title: "Saved", message: "Recipe has been saved for later use", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            APIManager.shared.saveRecipe(recipe: Recipe.init(dictionary: recipe), completion: { (err) in
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
    
    /*Table code end*/
    
    func getRecipies(completion: @escaping (Error?)->()){
        APIManager.shared.getAllCustomRecipes { (recipes, err) in
            if err != nil {
                print("Error loading")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.table.reloadData()
                }
                completion(err)
            }
            else {
                self.allRecipies = recipes!
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.table.reloadData()
                }
                completion(nil)
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getRecipies { (err) in
            self.updateTable(keywords: self.searchItem)
        }
    }
    
    @IBAction func sortByLikes(_ sender: Any) {
        if self.likesAsc {
            self.allRecipies = self.allRecipies.sorted(by: { ($0["likes"] as! Int) < ($1["likes"] as! Int) })
        } else {
            self.allRecipies = self.allRecipies.sorted(by: { ($0["likes"] as! Int) > ($1["likes"] as! Int) })
        }
        self.likesAsc = !self.likesAsc
        self.updateTable(keywords: self.searchItem)
    }
    

    @IBAction func sortByViews(_ sender: Any) {
        if self.viewsAsc {
            self.allRecipies = self.allRecipies.sorted(by: { ($0["views"] as! Int) < ($1["views"] as! Int) })
        } else {
            self.allRecipies = self.allRecipies.sorted(by: { ($0["views"] as! Int) > ($1["views"] as! Int) })
        }
        self.viewsAsc = !self.viewsAsc
        self.updateTable(keywords: self.searchItem)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselects cell after clicking on it
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "recipeDetailsSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! CustomRecipeCell
        let vc = segue.destination as! RecipeDetailsController
        var recipe = cell.customRecipe!
        APIManager.shared.updateViewsCount(customRecipe: recipe, value: (recipe["views"] as! Int) + 1, completion: { (err) in
            if let err = err {
                print(err)
            }
        })
        recipe["title"] = recipe["recipeName"]
        if let imageURL = recipe["imageURL"] as? String {
            recipe["thumbnail"] = imageURL
        }
        recipe["ingredients"] = recipe["description"]
        recipe["href"] = ""
        vc.selectedRecipe = Recipe(dictionary: recipe)
    }
    
}
