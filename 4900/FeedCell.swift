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
    var imageViews = [UIImageView]()
    var vHight: Float = 0
    let leftAndRightMargin: Float = 10
    let videoLeftMargin: Float = 2 //leftAndRightMargin - 8
    let baseVideoURL = " src=\"https://www.youtube.com/embed/"
    let baseVideoURL2 = "\" frameborder=\"0\" allowfullscreen></iframe>"
    var videoViews = [UIWebView]()
    
    //var post: Post? {
    var post: Story? {
        didSet{
            imageViews.removeAll()
            videoViews.removeAll()
            vHight = 0
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
                //estimate the height of the entire text
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: Int(viewWidth), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                vHight = vHight + Float(rect.height)
                statusTextView.text = statusText
            }
            
            if let imgs = post?.imgs{
                let imgsArray = imgs.components(separatedBy: ",")
                if imgsArray[0] != "" {
                    for img in imgsArray{
                        let imgURL = baseImgURL + img + exten
                        //create imageView to contain photo of the story
                        let statusImageView: UIImageView! = {
                            let imageView = UIImageView()
                            imageView.backgroundColor = UIColor(white: 0.95 , alpha: 1)

                            imageView.contentMode = .scaleAspectFit
                            return imageView
                        }()
                        getImage(imgURL, statusImageView)
                        imageViews.append(statusImageView)
                    }
                }
            }
            
            if let vidwos = post?.video{
                let videosArray = vidwos.components(separatedBy: ",")
                if videosArray[0] != "" {
                    for video in videosArray{
                        //create imageView to contain photo of the story
                        let statusVideoView: UIWebView! = {
                            let videoView = UIWebView()
                            let embedURL = "<iframe width=\"\(viewWidth - leftAndRightMargin)\" height=\"315\"" + baseVideoURL + video + baseVideoURL2
                            videoView.backgroundColor = UIColor(white: 0.95 , alpha: 1)
                            videoView.loadHTMLString(embedURL, baseURL: nil)
                            videoView.scrollView.isScrollEnabled = false
                            return videoView
                        }()
                        videoViews.append(statusVideoView)
                    }
                }
            }
            
            setuptViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setuptViews()
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
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    //add different conpolents to the cell and set it's constrain
    func setuptViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(statusTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-\(leftAndRightMargin)-[v0]-\(leftAndRightMargin)-|", views: statusTextView)
        addConstraintsWithFormat(format: "V:|-\(topMargin)-[v0(\(titleHight))]-\(spacing)-[v1]", views: nameLabel,statusTextView)
        vHight = vHight + topMargin + titleHight + offset
        
        for imageV in imageViews{
            addSubview(imageV)
            addConstraintsWithFormat(format: "H:|-\(leftAndRightMargin)-[v0]-\(leftAndRightMargin)-|", views: imageV)
            addConstraintsWithFormat(format: "V:|-\(vHight)-[v0(\(imageHight))]", views: imageV)
            vHight = vHight + imageHight + spacing
        }
        
        for videoV in videoViews{
            addSubview(videoV)
            addConstraintsWithFormat(format: "H:|-\(videoLeftMargin)-[v0]-\(leftAndRightMargin)-|", views: videoV)
            addConstraintsWithFormat(format: "V:|-\(vHight)-[v0(\(imageHight))]", views: videoV)
            vHight = vHight + imageHight + spacing
        }

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
                        UIView.animate(withDuration: 1.0, animations: { imageView.alpha = 1.0 })
                    })
                }
            }
        })
        task.resume()
    }
    
}
