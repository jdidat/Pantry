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
}

struct RecipeSearch: Decodable {
    var title: String
    var version: Double
    var href: String
    var results: [Recipe]
}
