//
//  WebViewController.swift
//  Pantry
//
//  Created by Samuel Carbone on 10/3/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var URL: URL?
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let URL = URL {
            let request = URLRequest(url: URL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.navigationController?.popViewController(animated: true)
                    print("ERROR: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.webView.load(request)
                    }
                }
            }
            task.resume()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
