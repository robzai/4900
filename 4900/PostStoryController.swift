//
//  PostStoryController.swift
//  4900
//
//  Created by Laura Yang on 2017-05-06.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit
import Foundation
import Photos
import AVKit
import DKImagePickerController

class PostStoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEMCheckBoxDelegate{
    
    
    @IBOutlet weak var box: BEMCheckBox!
    
    @IBOutlet weak var groupnametext: UITextField!
    @IBOutlet weak var reasontext: UITextField!
    @IBOutlet weak var actiontext: UITextField!
    @IBOutlet weak var storytext: UITextView!
    var agreetoshare = false
    var agreetosharestring = ""
    var piccount = 0

    
    let param = [
        "initialize" : "test",
        
        ] as NSMutableDictionary
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let leftAndRightPaddings: CGFloat = 8.0
    private let numberOfItemsPerRRow: CGFloat = 3.0
    private let heightAjustment: CGFloat = 30.0
    
    
    //1
    let pickerController = DKImagePickerController()
    var assets: [DKAsset]?
    
    //var PickedArray: [UIImage]?
    var env64string: NSString?
    
    //2
    @IBAction func showImagePicker(_ sender: Any) {
        piccount = 0
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
            
            // begin
            for asset in self.assets! {
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    print("line59")
                    //print(image)
                    
                    print("end line59")
                    
                    let imageUI = image! as UIImage
                    self.piccount += 1
                    //var imageString = "imageNumber" + String(self.piccount)
                    self.param.addEntries(from: [ "image" + String(self.piccount) : imageUI as UIImage])
                    print("image" + String(self.piccount) + "added")
                    
                })
                
            }
            
            print("\n End didSelectAssets")
            for each in assets{
                each.fetchOriginalImage(false){
                    (image: UIImage?, info: [AnyHashable : Any]?) in
                
                }
            }
            // end
            
            self.collectionView?.reloadData()
            
            
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}

    }
    
    //3
    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    //MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "New Post"
        //assign checkbox delegate
        box.delegate = self
        //set story textView boarder color
        storytext.layer.borderColor = UIColor.lightGray.cgColor;
        storytext.layer.borderWidth = 0.5
        
        //6
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PostStoryController.post))
        self.navigationItem.rightBarButtonItem = rightBarButton
        // Changing the colour of the bar button items
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let leftBarButton = UIBarButtonItem(title: "Cancle", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PostStoryController.cancle))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostStoryController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        //4
        return self.assets?.count ?? 0
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //5
        let asset = self.assets![indexPath.row]
        var cell: UICollectionViewCell?
        var imageView: UIImageView?
        
        if asset.isVideo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideo", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        }
        
        if let cell = cell, let imageView = imageView {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let tag = indexPath.row + 1
            cell.tag = tag
            
            asset.fetchImageWithSize(layout.itemSize.toPixel(), completeBlock: { image, info in
                if cell.tag == tag {
                    imageView.image = image
                }
            })
        }
        
        return cell!
    }

    //http://stackoverflow.com/questions/38509896/how-to-call-tab-bar-view-controller-by-click-button-function-in-swift
    func cancle() {
        self.tabBarController?.selectedIndex = 0
    }
    
    //yao editted from here
    func didTap(_ checkBox: BEMCheckBox) {
        
        print("tapped!!\(checkBox.tag):\(checkBox.on)")
        agreetoshare = checkBox.on
        
    }
    
    //pass images and text to php
    func post(){
        print(groupnametext.text! as String)
        print(agreetoshare)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://4900new.onebite.tk/update.php")! as URL)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        if(agreetoshare){
            agreetosharestring = "true"
        }else{
            agreetosharestring = "false"
        }
        
        self.param.addEntries(from: ["groupnametext" : groupnametext.text! as String])
        self.param.addEntries(from: ["reasontext" : reasontext.text! as String])
        self.param.addEntries(from: ["actiontext" : actiontext.text! as String])
        self.param.addEntries(from: ["storytext" : storytext.text! as String])
        self.param.addEntries(from: ["agreetoshare" : agreetosharestring])
        self.param.addEntries(from: ["totalimage" : String(piccount) as String])

        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            DispatchQueue.main.async {
                //                    //self.myActivityIndicator.stopAnimating()
                //                    //self.imageView.image = nil;
                //
            }
        }
        
        task.resume()
        
    }
    
    func createBodyWithParameters(parameters: NSMutableDictionary?,boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                
                if(value is String || value is NSString){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                    print("textttttt")
                }else if(value is UIImage ){
                    //var i = 0;
                   // for image in value as! [UIImage]{
                        let filename = "image\(piccount).png"
                        let data = UIImageJPEGRepresentation(value as! UIImage,0.01);
                        let mimetype = "image/png"
                        
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data! as Data)
                        body.appendString("\r\n")
                        //i += 1;
                        print("yes imageyyyyyyy")
                    //}
                }else{
                    print("no image nnnnn")
                }
            }
        }
        body.appendString("--\(boundary)--\r\n")
        //        NSLog("data %@",NSString(data: body, encoding: NSUTF8StringEncoding)!);
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assets![indexPath.row]
        asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
            DispatchQueue.main.async(execute: { () in
                self.playVideo(avAsset!)
            })
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}

//extension NSMutableData {
//    
//    func appendString(_ string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        append(data!)
//    }
//}
