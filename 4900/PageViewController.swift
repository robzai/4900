//
//  PageViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-16.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var viewControllerArr: [UIViewController] = {
        return [self.vcInstance(name: "FirstVC"), self.vcInstance(name: "SecondVC")]
    }()
    
    //go through the array and retrive the approate view controller
    private func vcInstance(name: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("Post")))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonTapped(sender:)))

        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.title = "New Post"
        
        //set what is you first viewController
        if let firstVC = viewControllerArr.first{
            setViewControllers( [firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func cancelButtonTapped(sender: UIBarButtonItem!){
        print("Cancel tapped")

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedController") as! FeedController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    // tell the current viewController what comes before in the array
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return viewControllerArr.last
        }
        
        guard viewControllerArr.count > previousIndex else {
            return nil
        }
        
        return viewControllerArr[previousIndex]
    }
    
    // tell the current viewController what comes after in the array
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < viewControllerArr.count else {
            return viewControllerArr.first
        }
        
        guard viewControllerArr.count > nextIndex else {
            return nil
        }
        
        return viewControllerArr[nextIndex]
    }
    
    //responsible for the dots at the bottom
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first, let firstVCIndex = viewControllerArr.index(of: firstVC) else {
            return 0
        }
        return firstVCIndex
    }
    
}
