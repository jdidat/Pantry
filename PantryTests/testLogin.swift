//
//  testLogin.swift
//  PantryTests
//
//  Created by Yanal Abusamen on 10/4/18.
//  Copyright © 2018 jdidat. All rights reserved.
//
@testable import Pantry
import XCTest

class testLogin: XCTestCase {

    var controller : LoginViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScreen") as! LoginViewController
        controller = vc
        controller.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTitleisPantry() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! LoginViewController
        let _ = login.view
        XCTAssertEqual("Pantry", login.title_label!.text!)
    }
    
    func testUsernamePlaceholder() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! LoginViewController
        let _ = login.view
        XCTAssertEqual("Email", login.email_address!.placeholder!)
    }
    
    func testHasLoginButtonWithSelfAsTarget() {
        let target = controller.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, nil)
    }
    
    func testLoginButtonResponseWithEmpty() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! LoginViewController
        login.loadViewIfNeeded()
        login.email_address!.text = ""
        login.password!.text = ""
        
        login.loginButton.sendActions(for: .touchUpInside)
        XCTAssertEqual("The password is invalid or the user does not have a password.", login.err_neither)
    }
    
    func testLoginButtonResponseWithEmptyEmail() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! LoginViewController
        login.loadViewIfNeeded()
        login.email_address!.text = ""
        login.password!.text = "password12#14!"
        
        login.loginButton.sendActions(for: .touchUpInside)
        XCTAssertEqual("The email address is badly formatted.", login.err_no_email)
    }
    
    
    
}
