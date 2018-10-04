//
//  TabViewController.swift
//  Pantry
//
//  Created by Joey Dafforn on 10/4/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import NightNight

class TabViewController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yeet")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if NightNight.theme == .night {
            myTabBar.barStyle = .black
        }
        else {
            myTabBar.barStyle = .blackOpaque
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
