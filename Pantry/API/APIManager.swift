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
        }
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.currentUserId = user.uid
            } else {
                self.currentUserId = ""
            }
        }
    }
    
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
    
    func createUser(email: String, password: String, username: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) ->
            Void in
            if (error == nil) {
                if let user = result?.user {
                    self.db.collection("users").document(user.uid).setData([
                        "username": username,
                        "rating": 0.0,
                        "recipeCount": 0
                        ], completion: ({err in
                            if let err = err {
                                completion(err)
                            } else {
                                completion(nil)
                            }
                        }))
                } else {
                    completion(error)
                }
            }
        })
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
        if !validateUser() {return}
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
                        recipeName: ["recipeName": recipeName, "description": description, "imageURL": String(describing: url!)]
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
                recipeName: ["recipeName": recipeName, "description": description, "imageURL": nil]
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
    
    func validateUser() -> Bool {
        return self.currentUserId.count > 0
    }
    
}
