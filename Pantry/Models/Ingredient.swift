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
    var count: Int
    init(dictionary: [String:Any]) {
        self.title = dictionary["title"] as! String
        self.count = dictionary["count"] as! Int
    }
    mutating func increment(){
        self.count += 1
    }
    mutating func decrement(){
        self.count -= 1
    }
}
extension Ingredient: Equatable {
    static func == (obj1: Ingredient, obj2: Ingredient) -> Bool {
        return
            obj1.title == obj2.title && obj1.count == obj2.count
    }
}
