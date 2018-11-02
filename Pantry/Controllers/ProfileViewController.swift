//
//  ProfileViewController.swift
//  Pantry
//
//  Created by Joseph Davey on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import AlamofireImage
import Cosmos
import NightNight

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var recipeNumber: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet var myView: UIView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    
    var customRecipes: [[String:Any]] = []
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customRecipes.count
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
        cell.customRecipe = customRecipes[indexPath.row]
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
                                    self.myTableView.reloadData()
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        if (NightNight.theme == .night) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            ratingView.backgroundColor = UIColor.black
            myTableView.backgroundColor = UIColor.black
            recipeNumber.textColor = UIColor.white
            ratingNumber.textColor = UIColor.white
            username.textColor = UIColor.white
            recipeLabel.textColor = UIColor.white
            ratingLabel.textColor = UIColor.white
        }
        else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            ratingView.backgroundColor = UIColor.white
            myTableView.backgroundColor = UIColor.white
            recipeNumber.textColor = UIColor.black
            ratingNumber.textColor = UIColor.black
            username.textColor = UIColor.black
            recipeLabel.textColor = UIColor.black
            ratingLabel.textColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.mixedBackgroundColor =  MixedColor(normal: 0xffffff, night: 0x000000)
        APIManager.shared.getCurrentUserData(completion: { (data, err) in
            if let data = data {
                self.username.text! = data["username"] as! String
                self.ratingNumber.text! = String(describing: data["rating"] as! Double)
                self.ratingView.rating = data["rating"] as! Double
                self.recipeNumber.text! = String(describing: data["recipeCount"] as! Int)
                if let url = URL(string: data["profileImageURL"] as! String) {
                    let urlRequest = URLRequest(url: url)
                    URLCache.shared.removeCachedResponse(for: urlRequest)
                    Alamofire.request(url).responseImage { (response) in
                        DispatchQueue.main.async {
                            self.profilePicture.image = response.value
                        }
                    }
                }
            } else {
                print(err!.localizedDescription)
            }
        })
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //Make Profile Picture Circular
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        profilePicture.isUserInteractionEnabled = true
        if (NightNight.theme == .night) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        }
        else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        navigationController?.navigationBar.topItem?.title = "Profile"
        // Do any additional setup after loading the view.
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.addSubview(self.refreshControl)
        self.refreshControl.beginRefreshing()
        getRecipies { (err) in
            if let err = err {
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.myTableView.reloadData()
                }
            }
        }
    }

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
                self.recipeNumber.text = String(self.customRecipes.count)
                completion(nil)
            }
        }
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getRecipies { (err) in
            if err == nil {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.myTableView.reloadData()
                }
            }
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true) {
        
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.image = image
            let data = UIImageJPEGRepresentation(image, 0.5)
            if let user = Auth.auth().currentUser {
                APIManager.shared.uploadImage(image: data!, path: "images/\(user.uid)/profile", completion: { (error, url) in
                    if error == nil && url != nil {
                        APIManager.shared.updateUserEntry(entry: "profileURL", value: String(describing: url!), completion: { (err) in
                            if err == nil {
                                let alert = UIAlertController(title: "Saved", message: "Profile image has been updated", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
