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
class APIManager {

    static let shared = APIManager()
    let db = Firestore.firestore()
    
    func get<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
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
                if let user = result {
                    self.db.collection("users").document(user.uid).setData([
                        "username": username,
                        "rating": 0.0,
                        "recipeCount": 0
                    ]) {err in
                        if let err = err {
                            completion(err)
                        } else {
                            completion(nil)
                        }
                    }
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
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (data, err) in
            if err != nil {
                completion(nil, err)
            } else {
                completion(data?.data(), nil)
            }
        }
    }
}
