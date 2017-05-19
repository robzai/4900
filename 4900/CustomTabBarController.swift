//
//  CustomTabBarContraoller.swift
//  4900
//
//  Created by leo  luo on 2017-05-06.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //first button to the tab bar
        let feedController =  FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navationConrtoller = UINavigationController(rootViewController: feedController)
        navationConrtoller.title = "Home"
        navationConrtoller.tabBarItem.image = UIImage(named: "home")
        
        
//        let newPostController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostStoryController")
        let newPostController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pageVC")
        //newPostController.navigationItem.title = "New Post"
        
        let newPostNavtionController = UINavigationController(rootViewController: newPostController)
        newPostNavtionController.title = "New Post"
        newPostNavtionController.tabBarItem.image = UIImage(named: "newPost")
 
        viewControllers = [navationConrtoller, newPostNavtionController]
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 0.2
        tabBar.layer.borderColor = UIColor(red:0.0/229.0, green:0.0/231.0, blue:0.0/235.0, alpha:0.2).cgColor
        tabBar.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
