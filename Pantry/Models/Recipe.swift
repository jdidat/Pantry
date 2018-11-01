//
//  Recipe.swift
//  Pantry
//
//  Created by Samuel Carbone on 9/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
    init(dictionary: [String:Any]) {
        self.title = dictionary["title"] as! String
        self.href = dictionary["href"] as! String
        self.ingredients = dictionary["ingredients"] as! String
        self.thumbnail = dictionary["thumbnail"] as! String
    }
}

struct RecipeSearch: Decodable {
    var title: String
    var version: Double
    var href: String
    var results: [Recipe]
}
