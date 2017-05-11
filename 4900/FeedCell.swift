//
//  File.swift
//  4900
//
//  Created by leo  luo on 2017-05-11.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit

//create and register cells, every time a cell is dequeue this will be called
class FeedCell: UICollectionViewCell{
    
    let baseImgURL = "http://4900.onebite.tk/pics/"
    let exten = ".png"
    
    //var post: Post? {
    var post: Story? {
        didSet{
            if let title = post?.action{
                if let group = post?.group{
                    let attriabutedText = NSMutableAttributedString(string: title + " " + group, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                    //add the post date
                    let postTime = post?.postTime
                    attriabutedText.append(NSAttributedString(string: "\n" + postTime!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    attriabutedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attriabutedText.string.characters.count))
                    
                    nameLabel.attributedText = attriabutedText
                }
            }
            
            if let statusText = post?.story{
                statusTextView.text = statusText
            }
            
            if let imgs = post?.imgs{
                let imgsArray = imgs.components(separatedBy: ",")
                for img in imgsArray{
                    let imgURL = baseImgURL + img + exten
                    getImage(imgURL, statusImageView)
                    //print("\n" + img)
                }
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
        addConstraintsWithFormat(format: "V:|-4-[v0(40)]-2-[v1]-2-[v2(300)]-2-|", views: nameLabel,statusTextView,statusImageView)
        
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
