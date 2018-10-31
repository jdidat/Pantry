//
//  testCookbook.swift
//  PantryTests
//
//  Created by Yanal Abusamen on 10/30/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

@testable import Pantry
import XCTest

class testCookbook: XCTestCase {
    
    var saved_recipes_controller : SavedRecipesController!
    var recipes: [Recipe] = []
    
    override func setUp() {
        
        let vc = UIStoryboard(name: "Recipes", bundle: nil).instantiateViewController(withIdentifier: "savedRecipesTab") as! SavedRecipesController
        saved_recipes_controller = vc
        saved_recipes_controller.loadViewIfNeeded()
        
        // put the recipe array into self
        self.recipes = saved_recipes_controller.recipes
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let rec0 = ["title": "mashed potatoes", "href": "http://google.com/mashed", "ingredients": "yellow potatoe, green onion, butter", "thumbnail": "mashed.jpg"]
        var r = Recipe.init(dictionary: rec0 as [String : Any])
        
        saved_recipes_controller.recipes.append(r)
        
        let rec1 = ["title": "chicken noodle soup", "href": "http://google.com/noodles", "ingredients": "boneless chicken tenders, potatoe, green onion, noodles", "thumbnail": "chknndle.png"]
        r = Recipe.init(dictionary: rec1 as [String: Any])
        
        saved_recipes_controller.recipes.append(r)
        
        let rec2 = ["title": "beef burrito", "href": "http://google.com/mex/burrito", "ingredients": "brown rice, green onion, tomatoe, groubd beef, cour cream, avocado, cheese", "thumbnail": "chipotle.png"]
        r = Recipe.init(dictionary: rec2 as [String: Any])
        saved_recipes_controller.recipes.append(r)
        
        let rec3 = ["title": "fried rice", "href": "http://google.com/chinese/rice", "ingredients": "soy sauce, green onion, white rice", "thumbnail": "friedrice.png"]
        r = Recipe.init(dictionary: rec3 as [String: Any])
        saved_recipes_controller.recipes.append(r)
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.saved_recipes_controller = nil
        // free on tear down
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRecipeT() {
        let thumb: String = "friedrice.png"
        // get the value of thumb from the cookbook page
        let get_thumbnail: String = saved_recipes_controller.recipes[3].thumbnail
        
        XCTAssertEqual(thumb, get_thumbnail)
    }
    
    func testRecipeN() {
        let name: String = saved_recipes_controller.recipes[0].title
        XCTAssertEqual(name, "mashed potatoes")
    }
    
    func testRecipeI() {
        let ing: String = saved_recipes_controller.recipes[2].ingredients
        XCTAssertEqual(ing, "brown rice, green onion, tomatoe, groubd beef, cour cream, avocado, cheese")
    }

    func testExam() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRecipeH() {
        let ref: String = saved_recipes_controller.recipes[1].href
        // compare link to the one on the cookbook page
        let get_href: String = "http://google.com/noodles"
        XCTAssertEqual(get_href, ref)
    }
    
    
    
}
