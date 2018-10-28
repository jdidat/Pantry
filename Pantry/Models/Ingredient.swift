//
//  Ingredient.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/28/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import Foundation

struct Ingredient: Decodable {
    var title: String
    init(title: String) {
        self.title = title
    }
}
