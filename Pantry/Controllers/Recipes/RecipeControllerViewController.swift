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
    var salmonColor: UIColor = UIColor.init(red: 254/255, green: 105/255, blue: 100/255, alpha: 1.0)
    
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
    // The following few lines allow the current segment bar to be animated
    // and actually follow the current segment
    class Responder: NSObject {
        @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
//            UIView.animate(withDuration: 0.3) {
//                self.buttonBar.frame.origin.x = (self.segmentController.frame.width / CGFloat(self.segmentController.numberOfSegments)) * CGFloat(self.segmentController.selectedSegmentIndex)
//            }
        }
    }
    let responder = Responder()
    let buttonBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Makes segmented controller REAL nice
        segmentController.backgroundColor = UIColor.clear
        segmentController.tintColor = UIColor.clear
        segmentController.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18), NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        segmentController.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedStringKey.foregroundColor: salmonColor
            ], for: .selected)
        // Button below segmented controller showing current segment
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = salmonColor
        view.addSubview(buttonBar)
        // Constraints for the button
        buttonBar.topAnchor.constraint(equalTo: segmentController.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentController.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentController.widthAnchor, multiplier: 1 / CGFloat(segmentController.numberOfSegments)).isActive = true
        
        segmentController.addTarget(responder, action: #selector(responder.segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)

        navigationController?.navigationBar.topItem?.title = "Recipes"
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
