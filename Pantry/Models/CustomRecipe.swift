//
//  CustomRecipe.swift
//  Pantry
//
//  Created by Samuel Carbone on 11/1/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation

struct CustomRecipe: Decodable {
    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
    var likes: Int
    init(dictionary: [String:Any]) {
        self.title = dictionary["title"] as! String
        self.href = dictionary["href"] as! String
        self.ingredients = dictionary["ingredients"] as! String
        self.thumbnail = dictionary["thumbnail"] as! String
        self.likes = dictionary["likes"] as! Int
    }
}
