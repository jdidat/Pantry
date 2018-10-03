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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    var customRecipes : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.addSubview(self.refreshControl)
        self.refreshControl.beginRefreshing()
        getRecipies { (err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.table.reloadData()
                }
            }
        }
    }
    
    /* Table code start */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRecipeCell", for: indexPath) as! CustomRecipeCell
        cell.customRecipeImage.image = UIImage(named: "default")
        cell.customRecipe = customRecipes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at: IndexPath) -> UIContextualAction {
        let recipe = self.customRecipes[at.row]
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getRecipies { (err) in
            if err == nil {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.table.reloadData()
                }
            }
        }
        
    }
    
    /*Table code end*/
    
    func getRecipies(completion: @escaping (Error?)->()){
        APIManager.shared.getCustomRecipes { (customRecipes: [[String:Any]]?, err) in
            if let err = err {
                switch err {
                case APIManager.ErrorCodes.notFound:
                    //Add UI label to tell user to add recipe
                    break
                default:
                    print("Unknown error")
                }
                completion(err)
            } else {
                self.customRecipes = customRecipes!
                completion(nil)
            }
        }
    }
    
}
