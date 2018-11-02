//
//  testPantryContents.swift
//  PantryTests
//
//  Created by Yanal Abusamen on 11/1/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

@testable import Pantry
import XCTest

var controller: PantryViewController!

let rec0 = ["title": "yo man", "count": "0"]

class testPantryContents: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContents() {
       // let r = Ingredient.init(dictionary: rec0 as [String : Any])
        
        let vc = UIStoryboard(name: "Pantry", bundle: nil).instantiateViewController(withIdentifier: "pantryTab") as! PantryViewController
        controller = vc
        controller.loadViewIfNeeded()
        controller.ingredientTitleInput.text = "tomato"
        let ingredient_title = "tomato"

        
        XCTAssertEqual("tomato", ingredient_title)
    }
    
    func testPantryObject() {
        // let r = Ingredient.init(dictionary: rec0 as [String : Any])
        
        let vc = UIStoryboard(name: "Pantry", bundle: nil).instantiateViewController(withIdentifier: "pantryTab") as! PantryViewController
        controller = vc
        controller.loadViewIfNeeded()
        controller.ingredientTitleInput.text = "Green Onion"
        let ingredient_title = "Green Onion"
        
        
        XCTAssertEqual("Green Onion", ingredient_title)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPantryObject2() {
        // let r = Ingredient.init(dictionary: rec0 as [String : Any])
        
        let vc = UIStoryboard(name: "Pantry", bundle: nil).instantiateViewController(withIdentifier: "pantryTab") as! PantryViewController
        controller = vc
        controller.loadViewIfNeeded()
        controller.ingredientTitleInput.text = "Ground Beef"
        let ingredient_title = "Ground Beef"
        
        
        XCTAssertEqual("Ground Beef", ingredient_title)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
