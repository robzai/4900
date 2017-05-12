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

let cellId = "cellId"
var viewWidth: Float = 0

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var objects = [JSON]()
    //create an array which contain all the posts
    var posts = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = Float(view.frame.width)
        
        if !isInternetAvailable() {
            self.createAlert(titleMsg: "Alert", messageMsg: "ooop something wrong~")
        }
        
        
        Alamofire.request("http://4900.onebite.tk/jason.php").responseJSON {
            response in
            if let  rawJSON = response.result.value {
                let json = JSON(rawJSON)
                
                for (_, subJSON) : (String, JSON) in json
                {
                    
                    let jReason = subJSON["reason"].stringValue
                    let jAction = subJSON["action"].stringValue
                    let jGroup = subJSON["groupname"].stringValue
                    let jStory = subJSON["textstories"].stringValue
                    let jImgs = subJSON["images"].stringValue
                    let jVideo = subJSON["video"].stringValue
                    let jPostTime = subJSON["posttime"].stringValue
                    
                    //print("\(reason) -> \(action)")
                    let story = Story(reason: jReason, action: jAction, group: jGroup, story: jStory, imgs: jImgs, video: jVideo, postTime: jPostTime)
                    self.posts.append(story)
                    
                }
            }
            self.collectionView?.reloadData()
        }
        
        navigationItem.title = "RMHC"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        //register cells for the collection view
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
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
    
    func createAlert(titleMsg:String, messageMsg:String){
        let alert = UIAlertController(title: titleMsg, message: messageMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Collection View
    
    //return number of items in the session(collection view)
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //actually return the cells for each of the items
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! FeedCell
        
        //do the post setting, which means it will execute the didSet inside the FeedCell.post
        feedCell.post = posts[indexPath.item]
        
        return feedCell
    }
    
    //specify the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].story{
            //estimate the height of the entire text
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            let fixedHight: CGFloat = 4 + 40 + 2 + 300 + 2 + 600
            return CGSize(width: view.frame.width, height: rect.height + fixedHight + 26)
        }
        
        return CGSize(width: view.frame.width, height: 400)
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
