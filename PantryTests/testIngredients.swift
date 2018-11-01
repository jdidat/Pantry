//
//  testIngredients.swift
//  PantryTests
//
//  Created by Yanal Abusamen on 11/1/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

@testable import Pantry
import XCTest

class testIngredients: XCTestCase {
    
    // set up the view controller by initializing it in this method, so we can pull data from it to see if it is accurate
    
    var controller: RecipeDetailsController!
    
    let rec0 = ["title": "mashed potatoes", "href": "http://google.com/", "ingredients": "yellow potatoe, green onion, butter", "thumbnail": "https://www.google.com/imgres?imgurl=https%3A%2F%2Fdevfest.gdg-taipei.org%2Fimages%2Flogos%2Fgoogle.svg&imgrefurl=https%3A%2F%2Fwww.google.com%2Fabout%2F&docid=yXFSdWy6pepTVM&tbnid=KxPNDNLnr0KauM%3A&vet=10ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwhtKAEwAQ..i&w=1000&h=329&client=safari&bih=923&biw=1629&q=google%20images&ved=0ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwhtKAEwAQ&iact=mrc&uact=8"]

    let rec1 = ["title": "chicken noodle soup", "href": "https://www.google.com/imgres?imgurl=https%3A%2F%2Flookaside.fbsbx.com%2Flookaside%2Fcrawler%2Fmedia%2F%3Fmedia_id%3D152123811486349&imgrefurl=https%3A%2F%2Fwww.facebook.com%2FGoogleSmallBiz%2F&docid=g6QAjJSQ-9vtYM&tbnid=MHuTLnpX638zfM%3A&vet=10ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwh5KA0wDQ..i&w=960&h=901&client=safari&bih=923&biw=1629&q=google%20images&ved=0ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwh5KA0wDQ&iact=mrc&uact=8", "ingredients": "boneless chicken tenders, potatoe, green onion, noodles", "thumbnail": "chknndle.png"]
    
    let rec2 = ["title": "beef burrito", "href": "https://www.google.com/imgres?imgurl=https%3A%2F%2Fakm-img-a-in.tosshub.com%2Findiatoday%2Fgoogle-apps-thumb-559_120517104011_0.jpg%3FENIc7eh9xZiGz9Zv7PoE4Jr5r0J7dmIk&imgrefurl=https%3A%2F%2Fwww.indiatoday.in%2Ftechnology%2Ftalking-points%2Fstory%2Fa-day-without-google-apps-the-good-the-bad-and-the-ugly-1100453-2017-12-05&docid=mJ7X9EZtIMYowM&tbnid=biow6aDBvxNAEM%3A&vet=10ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwh-KBIwEg..i&w=559&h=349&client=safari&bih=923&biw=1629&q=google%20images&ved=0ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwh-KBIwEg&iact=mrc&uact=8", "ingredients": "brown rice, green onion, tomatoe, groubd beef, cour cream, avocado, cheese", "thumbnail": "chipotle.png"]
    
    let rec3 = ["title": "fried rice", "href": "http://google.com/chinese/rice", "ingredients": "soy sauce, green onion, white rice", "thumbnail": "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn0.tnwcdn.com%2Fwp-content%2Fblogs.dir%2F1%2Ffiles%2F2018%2F02%2Fgoogle-pacman-796x419.jpg&imgrefurl=https%3A%2F%2Fthenextweb.com%2Fgaming%2F2018%2F02%2F07%2Freport-googles-working-on-a-streaming-game-platform-called-yeti%2F&docid=G1NF-xOadwk7OM&tbnid=1R2baY57iJhJlM%3A&vet=10ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwhyKAYwBg..i&w=796&h=419&client=safari&bih=923&biw=1629&q=google%20images&ved=0ahUKEwi4mt6p5LPeAhVj_4MKHcDmDm0QMwhyKAYwBg&iact=mrc&uact=8"]

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let vc = UIStoryboard(name: "Recipes", bundle: nil).instantiateViewController(withIdentifier: "recipeDetailsTab") as! RecipeDetailsController
        controller = vc
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.controller = nil
    }
    
    func testIngredient1() {

        let r = Recipe.init(dictionary: rec0 as [String : Any])
        controller.selectedRecipe = r
        controller.loadViewIfNeeded()
        
        var get_ingredient: String = "yellow potatoe, green onion, butter"
        // get the ingredient that we are checking for
        let get_ing_app: String = self.controller.recipeIngredients.text!
        XCTAssertEqual(get_ing_app, get_ingredient)
        get_ingredient = ""
    }
    
    func testIngredient2() {
        let r = Recipe.init(dictionary: rec1 as [String : Any])
        controller.selectedRecipe = r
        controller.loadViewIfNeeded()
        
        var get_ingredient: String = "boneless chicken tenders, potatoe, green onion, noodles"
        // get the ingredient that we are checking for
        let get_ing_app: String = self.controller.recipeIngredients.text!
        XCTAssertEqual(get_ing_app, get_ingredient)
        get_ingredient = ""
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testIngredient3() {
    
        let r = Recipe.init(dictionary: rec2 as [String : Any])
        controller.selectedRecipe = r
        controller.loadViewIfNeeded()
    
        var get_ingredient: String = "brown rice, green onion, tomatoe, groubd beef, cour cream, avocado, cheese"
        // get the ingredient that we are checking for
        let get_ing_app: String = self.controller.recipeIngredients.text!
        XCTAssertEqual(get_ing_app, get_ingredient)
        get_ingredient = ""
    }
    
    func testIngredient4() {
        
        let r = Recipe.init(dictionary: rec3 as [String : Any])
        controller.selectedRecipe = r
        controller.loadViewIfNeeded()
        
        var get_ingredient: String = "soy sauce, green onion, white rice"
        // get the ingredient that we are checking for
        let get_ing_app: String = self.controller.recipeIngredients.text!
        XCTAssertEqual(get_ing_app, get_ingredient)
        get_ingredient = ""
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
