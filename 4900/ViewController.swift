//
//  ViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-03.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

let cellId = "cellId"

//a model obj for each post
class Post{
    var title: String?
    var statusText: String?
    var statusImageName: String?
}

class FeedController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    //create an array which contain all the posts
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let post1 = Post()
        post1.title = "title of post 1"
        post1.statusText = "content of post 1_content of post 1_content of post 1_content of post 1_"
        post1.statusImageName = "pic1"
        
        let post2 = Post()
        post2.title = "title of post 2"
        post2.statusText = "content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_content of post 2_"
        post2.statusImageName = "pic2"
        
        posts.append(post1)
        posts.append(post2)
        
        navigationItem.title = "RMHC"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        //register cells for the collection view
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

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
        if let statusText = posts[indexPath.item].statusText{
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
    
    var post: Post? {
        didSet{
            if let title = post?.title{
                let attriabutedText = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                //bottom line text
                attriabutedText.append(NSAttributedString(string: "\nMay 4", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attriabutedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attriabutedText.string.characters.count))
                
                nameLabel.attributedText = attriabutedText
            }
            
            if let statusText = post?.statusText{
                statusTextView.text = statusText
            }
            
            if let statusImage = post?.statusImageName{
                statusImageView.image = UIImage(named: statusImage)
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
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "pic1")
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
