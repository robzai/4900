//
//  ViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-03.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import SystemConfiguration


var viewWidth: Float = 0
let topMargin: Float = 4
let bottomMargin: Float = 2
let titleHight: Float = 40
let spacing: Float = 2
let imageHight: Float = 300
let offset: Float = 26

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
  
    let dataSource = "http://4900.onebite.tk/jason.php"
    let cellId = "cellId"
    var refresher: UIRefreshControl!
    
    //create an array which contain all the posts
    var posts = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = Float(view.frame.width)

        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
        //when the refresher is actived call the cunction in selector
        refresher.addTarget( self, action: #selector(FeedController.refreshData), for: .valueChanged)
        collectionView?.addSubview(refresher)
        
        refreshData()
        
        navigationItem.title = "RMHC"
        //collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        //register cells for the collection view
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
    }

    func refreshData(){
        if !isInternetAvailable() {
            self.createAlert(titleMsg: "Alert", messageMsg: "ooop no internet connection~")
        }
        Alamofire.request(dataSource).responseJSON {
            response in
            if let  rawJSON = response.result.value {
                let json = JSON(rawJSON)
                self.posts.removeAll()
                for (_, subJSON) : (String, JSON) in json{
                    
                    let jReason = subJSON["reason"].stringValue
                    let jAction = subJSON["action"].stringValue
                    let jGroup = subJSON["groupname"].stringValue
                    let jStory = subJSON["textstories"].stringValue
                    let jImgs = subJSON["images"].stringValue
                    let jVideo = subJSON["video"].stringValue
                    let jPostTime = subJSON["posttime"].stringValue
                    
                    let story = Story(reason: jReason, action: jAction, group: jGroup, story: jStory, imgs: jImgs, video: jVideo, postTime: jPostTime)
                    self.posts.append(story)
                    
                }
                self.collectionView?.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //create the alert message
    //http://stackoverflow.com/questions/24195310/how-to-add-an-action-to-a-uialertview-button-using-swift-ios
    func createAlert(titleMsg:String, messageMsg:String){
        let alert = UIAlertController(title: titleMsg, message: messageMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.refresher.endRefreshing()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Collection View
    
    //return number of items in the session(collection view)
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //actually return the cells for each of the items, cells will reload when scroll or refresh
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! FeedCell
        //clear subviews in the cell, otherwise subviews keep redrawing themselve in the cell
        let subviews = feedCell.subviews
        print("****************\(subviews.count)")
        for subview in subviews{
            subview.removeFromSuperview()
        }
        print("--------------\(subviews.count)")
        //do the post setting, which means it will execute the didSet inside the FeedCell.post, here will readd all the subviews
        feedCell.post = posts[indexPath.item]
        return feedCell
    }
    
    //specify the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var hight: Float = topMargin + titleHight + spacing + offset + bottomMargin
        if let statusText = posts[indexPath.item].story{
            //estimate the height of the entire text
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            hight = hight + Float(rect.height)
        }
        
        if let imgs = posts[indexPath.item].imgs{
            var count: Float = 0
            let imgsArray = imgs.components(separatedBy: ",")
            if imgsArray[0] != "" {
                for _ in imgsArray{
                    count = count + 1
                }
            }
            hight = hight + imageHight * count
        }
        
        return CGSize(width: view.frame.width, height: CGFloat(hight + 26))
    }

}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){    //UIView... means views will come in as an array
        var viewDictionary = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))

    }
}
