//
//  APIManager.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation


func APIManager<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
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

