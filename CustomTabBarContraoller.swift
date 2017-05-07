//
//  CustomTabBarContraoller.swift
//  4900
//
//  Created by leo  luo on 2017-05-06.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

class CustomTabBarContraoller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //first button to the tab bar
        let feedController =  FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navationConrtoller = UINavigationController(rootViewController: feedController)
        navationConrtoller.title = "Home"
        navationConrtoller.tabBarItem.image = UIImage(named: "home")
        
        //second button to the tab bar
        let newPostController = UIViewController()
        newPostController.navigationItem.title = "New Post"
        let newPostNavtionController = UINavigationController(rootViewController: newPostController)
        newPostNavtionController.title = "New Post"
        newPostNavtionController.tabBarItem.image = UIImage(named: "newPost")
        
        viewControllers = [navationConrtoller, newPostNavtionController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
