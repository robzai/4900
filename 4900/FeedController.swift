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

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var objects = [JSON]()
    //create an array which contain all the posts
    //var posts = [Post]()
    var posts = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    let jPostTime = subJSON["posttime"].intValue
                    
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
            let fixedHight: CGFloat = 4 + 40 + 2 + 300
            return CGSize(width: view.frame.width, height: rect.height + fixedHight + 26)
        }
        
        return CGSize(width: view.frame.width, height: 400)
    }

}

//create and register cells, every time a cell is dequeue this will be called
class FeedCell: UICollectionViewCell{
    
    //var post: Post? {
    var post: Story? {
        didSet{
            if let title = post?.group{
                let attriabutedText = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                //bottom line text
                attriabutedText.append(NSAttributedString(string: "\nMay 4", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attriabutedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attriabutedText.string.characters.count))
                
                nameLabel.attributedText = attriabutedText
            }
            
            if let statusText = post?.story{
                statusTextView.text = statusText
            }
            
            if let statusImageURL = post?.imgs{
                //statusImageView.image = UIImage(named: statusImage)
                getImage(statusImageURL, statusImageView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setuptViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //create a label to contain the title of the story
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    //create textView to contain the content of the story
    let statusTextView: UITextView = {
        let textView = UITextView()
        //textView.text = "content can goes here-content can goes here-content can goes here-content can goes here-content can goes here-content can goes here-content can goes here-content can goes here-"
        //textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    //create imageView to contain photo of the story
    let statusImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //add different conpolents to the cell and set it's constrain
    func setuptViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(statusTextView)
        addSubview(statusImageView)
        //put the name label on the screen and expand left to right, also 8 pix frome the left
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusImageView)
        addConstraintsWithFormat(format: "V:|-4-[v0(40)]-2-[v1]-2-[v2(300)]|", views: nameLabel,statusTextView,statusImageView)
        
    }
    
    //https://www.youtube.com/watch?v=Z6D68MMx2pw
    func getImage(_ url_str:String, _ imageView:UIImageView){
        
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if data != nil{
                let image = UIImage(data: data!)
                
                if(image != nil){
                    DispatchQueue.main.async(execute: {
                        
                        imageView.image = image
                        imageView.alpha = 0
                        UIView.animate(withDuration: 2.5, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
            }
        })
        task.resume()
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
