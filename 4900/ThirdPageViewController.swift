//
//  SecondPageViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-16.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

class ThirdPageViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        
        let url = URL (string: "https://www.youtube.com/")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
