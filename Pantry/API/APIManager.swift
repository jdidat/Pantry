//
//  APIManager.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
class APIManager {
    
    init() {
        if let user = Auth.auth().currentUser {
            self.currentUserId = user.uid
            self.currentUser = user
        }
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.currentUserId = user.uid
                self.currentUser = user
            } else {
                self.currentUserId = ""
            }
        }
    }
    
    
    var currentUser: User?
    var currentUserId: String = ""
    static let shared = APIManager()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    enum ErrorCodes: Error {
        case notFound
    }
    
    func get<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        if !validateUser() {return}
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, respose, err) in
            guard let data = data else {return}
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch let jsonErr {
                print(jsonErr.localizedDescription)
            }
            }.resume()
    }
    
    func createUser(email: String, password: String, username: String, image: UIImage?, completion: @escaping (Error?) -> ()) {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) ->
                Void in
                if error == nil {
                    if let image = image {
                        if let user = result?.user {
                            let imageData = UIImageJPEGRepresentation(image, 0.5)
                            self.uploadImage(image: imageData!, path: "images/\(user.uid)/profile", completion: { (error, url) in
                                if error == nil {
                                    self.instantiateUserFirebase(username: username, user: user, imageURL: url, completion: { (error) in
                                        if error == nil {
                                            completion(nil)
                                        } else {
                                            completion(error)
                                        }
                                    })
                                } else {
                                    completion(error)
                                }
                            })
                        }
                    } else {
                        if let user = result?.user {
                            self.instantiateUserFirebase(username: username, user: user, imageURL: nil, completion: { (error) in
                                if error == nil {
                                    completion(nil)
                                } else {
                                    completion(error)
                                }
                            })
                        }
                    }
                } else {
                    completion(error)
                }
            })
    }
    
    
    func instantiateUserFirebase(username: String, user: User, imageURL: URL?, completion: @escaping (Error?)->()) {
        var urlString = ""
        if let url = imageURL {
            urlString = String(describing: url)
        }
        self.db.collection("users").document(user.uid).setData([
            "username": username,
            "rating": 0.0,
            "recipeCount": 0,
            "profileImageURL": urlString
            ], completion: ({err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
            })
        )
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if err != nil {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func getCurrentUserData(completion: @escaping ([String: Any]?, Error?) -> ()) {
        if !validateUser() {return}
        db.collection("users").document(currentUserId).getDocument { (data, err) in
            if err != nil {
                completion(nil, err)
            } else {
                completion(data?.data(), nil)
            }
        }
    }
    
    func uploadImage(image: Data, path: String, completion: @escaping (Error?, URL?) -> ()) {
        let ref = storageRef.child(path)
        ref.putData(image, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                completion(error, nil)
            } else {
                ref.downloadURL { (url, error) in
                    if let error = error {
                        completion(error, nil)
                    } else {
                        completion(nil, url)
                    }
                }
            }
        })
    }
    
    func createCustomRecipe(recipeName: String, description: String, image: UIImage?, completion: @escaping (Error?) -> ()) {
        if !validateUser() {return}
        if let image = image {
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            self.uploadImage(image: imageData!, path: "images/\(self.currentUserId)/\(recipeName)", completion: { (error, url) in
                if error == nil {
                    self.db.collection("customRecipes").document(self.currentUserId).setData([
                        recipeName: ["recipeName": recipeName, "description": description, "imageURL": String(describing: url!), "likes": 0, "ownerId": self.currentUser?.uid, "views": 0]
                    ], merge: true) {err in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    }
                } else {
                    completion(error)
                }
            })
        } else {
            db.collection("customRecipes").document(self.currentUserId).setData([
                recipeName: ["recipeName": recipeName, "description": description, "imageURL": nil, "likes": 0, "ownerId": self.currentUser?.uid, "views": 0]
            ], merge: true) {err in
                if let err = err {
                    completion(err)
                }
                else {
                    completion(nil)
                }
            }
        }
    }
    
    
    func deleteCutomRecipe(recipeName: String, completion: @escaping (Error?) -> ()) {
        if !validateUser() {return}
        getCustomRecipes { (recipes, error) in
            var values:[String:Any] = [:]
            if let error = error {
                completion(error)
            } else {
                for recipeValues in recipes! {
                    if let currentRecipeName = recipeValues["recipeName"] as? String {
                        if  currentRecipeName == recipeName {
                            continue;
                        }
                        values[currentRecipeName] = recipeValues
                    }
                }
                self.db.collection("customRecipes").document(self.currentUserId).setData(values) {err in
                    if let err = err {
                        completion(err)
                    }
                    else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func getCustomRecipes(completion: @escaping ([[String : Any]]?, Error?) -> ()) {
        if !validateUser() {return}
        db.collection("customRecipes").document(self.currentUserId).getDocument { (data, err) in
            var customRecipies: [[String:Any]] = []
            if err != nil  {
                completion(nil, err)
            } else if let data = data?.data() {
                for (_, recipeValues) in data {
                    customRecipies.append(recipeValues as! [String:Any])
                }
                completion(customRecipies, nil)
            } else {
                completion(nil, ErrorCodes.notFound)
            }
        }
    }
    
    func updateUserEntry(entry: String, value: String, completion: @escaping (Error?)->()) {
        db.collection("users").document(self.currentUserId).setData([entry:value], merge: true) {err in
            if err == nil {
                completion(nil)
            } else {
                completion(err)
            }
        }
    }
    
    func saveRecipe(recipe: Recipe, completion: @escaping(Error?) -> ()) {
        if !validateUser() {return}
        let recipeTitle = recipe.title
        db.collection("saved").document(self.currentUserId).setData([
            recipeTitle:[
                "title": recipe.title,
                "href": recipe.href,
                "ingredients": recipe.ingredients,
                "thumbnail": recipe.thumbnail
            ]
        ], merge:true) {err in
            if err == nil {
                completion(nil)
            } else {
                completion(err)
            }
        }
    }
    
    
    func getSavedRecipes(completion: @escaping([Recipe]?, Error?) -> ()) {
        db.collection("saved").document(self.currentUserId).getDocument { (data, err) in
            var savedRecipes: [Recipe] = []
            if err != nil  {
                completion(nil, err)
            } else if let data = data?.data() {
                for (_, recipeValues) in data {
                    savedRecipes.append(Recipe.init(dictionary: recipeValues as! [String : Any]))
                }
                completion(savedRecipes, nil)
            } else {
                completion(nil, ErrorCodes.notFound)
            }
        }
    }
    
    func getAllCustomRecipes(completion: @escaping([[String : Any]]?, Error?)->()) {
        db.collection("customRecipes").getDocuments { (data, err) in
            var customRecipes: [[String : Any]] = []
            if err != nil  {
                completion(nil, err)
            } else if let data = data {
                for document in data.documents {
                    for (_, recipeValues) in document.data() {
                        let dataString = recipeValues as! [String : Any]
                        customRecipes.append(dataString)
                    }
                }
                completion(customRecipes, nil)
            } else {
                completion(nil, ErrorCodes.notFound)
            }
        }
    }
    
    func updateVotes(recipe: [String:Any], value: Int, completion: @escaping(Error?)->()) {
        let recipeName = recipe["recipeName"] as! String
        let recipeOwner = recipe["ownerId"] as! String
        let recipeLikes = recipe["likes"] as! Int
        db.collection("customRecipes").document(recipeOwner).getDocument(completion: { (data, err) in
            if let data = data {
                let values = data.data()
                if let values = values {
                    for(key, _) in values {
                        if key == recipeName {
                            self.db.collection("customRecipes")
                                .document(recipeOwner)
                                .setData([recipeName: ["likes": recipeLikes + value]], merge: true) { err in
                                    if err == nil {
                                        completion(nil)
                                    } else {
                                        completion(err)
                                    }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func deleteSavedRecipe(recipeName: String, completion: @escaping(Error?)->()) {
        db.collection("saved").document(currentUserId).updateData([
            recipeName: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
        }
    }
    
    func editCustomRecipe(customRecipe: [String:Any], newRecipeName: String, description: String, completion: @escaping (Error?) -> ()) {
        let oldRecipeName = customRecipe["recipeName"] as! String
        db.collection("customRecipes").document(currentUserId).updateData([
            oldRecipeName: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    completion(err)
                } else {
                    let oldImage = customRecipe["imageURL"] as? String
                    let oldLikes = customRecipe["likes"] as! Int
                    let oldViews = customRecipe["views"] as! Int
                    self.db.collection("customRecipes").document(self.currentUserId).setData([
                        newRecipeName: ["recipeName": newRecipeName, "description": description, "imageURL": oldImage, "likes": oldLikes, "ownerId": self.currentUser?.uid, "views": oldViews]
                    ], merge: true) {err in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    }
                }
        }
    }
    
    func updateViewsCount(customRecipe: [String:Any], value: Int, completion: @escaping(Error?) -> ()){
        let ownerId = customRecipe["ownerId"] as! String
        let recipeName = customRecipe["recipeName"] as! String
        db.collection("customRecipes").document(ownerId).setData([recipeName: ["views": value]], merge: true)
        { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
        }
    }
    
    func getDirections(urlString: String, completion: @escaping(Data?, Error?) -> ()){
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, respose, err) in
            guard let data = data else {return}
            do {
                completion(data, nil)
            } catch let jsonErr {
                print(jsonErr.localizedDescription)
            }
            }.resume()
    }
    
    func validateUser() -> Bool {
        return self.currentUserId.count > 0
    }
    
}
