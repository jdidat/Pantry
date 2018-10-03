//
//  RecipeControllerViewController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/2/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit

class RecipeControllerViewController: UIViewController {
    
    var currentViewController: UIViewController?
    
    @IBOutlet weak var contentView: UIView!
    
    
    enum TabIndex : Int {
        case discoverTab = 0
        case customRecipesTab = 1
        case savedRecipesTab = 2
    }
    
    lazy var discoverTab: UIViewController? = {
        let discoverTab = self.storyboard?.instantiateViewController(withIdentifier: "discoverRecipesTab")
        return discoverTab
    }()
    
    lazy var customRecipeTab : UIViewController? = {
        let customRecipeTab = self.storyboard?.instantiateViewController(withIdentifier: "customRecipesTab")
        
        return customRecipeTab
    }()
    
    lazy var savedRecipesTab : UIViewController? = {
        let savedRecipesTab = self.storyboard?.instantiateViewController(withIdentifier: "savedRecipesTab")
        
        return savedRecipesTab
    }()
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.selectedSegmentIndex = TabIndex.discoverTab.rawValue
        displayCurrentTab(TabIndex.discoverTab.rawValue)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
            case TabIndex.discoverTab.rawValue :
                vc = discoverTab
            case TabIndex.customRecipesTab.rawValue :
                vc = customRecipeTab
            case TabIndex.savedRecipesTab.rawValue :
                vc = savedRecipesTab
            default:
                return nil
        }
        
        return vc
    }
}
