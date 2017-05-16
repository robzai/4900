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
<<<<<<< HEAD
                    //let imageData = UIImageJPEGRepresentation(image!, 1)
=======
                    let imageData = UIImageJPEGRepresentation(image!, 1)
>>>>>>> 5eca6626743f4ab1be52d584ff9f67e42440373d

                    self.piccount += 1
                    //var imageString = "imageNumber" + String(self.piccount)
                    self.param.addEntries(from: [ "image" + String(self.piccount) : imageUI as UIImage])
                    print("image" + String(self.piccount) + "added")
                    
//                    self.env64string = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//                    self.env64strings[env64string] = image // the env64strings is a dictionary.
                })
                
            }
            
            print("\n End didSelectAssets")
            for each in assets{
                each.fetchOriginalImage(false){
                    (image: UIImage?, info: [AnyHashable : Any]?) in
<<<<<<< HEAD
                    //let imageData: NSData = UIImagePNGRepresentation(image!)! as NSData
=======
                    let imageData: NSData = UIImagePNGRepresentation(image!)! as NSData
>>>>>>> 5eca6626743f4ab1be52d584ff9f67e42440373d
                    //print(String(data: (imageData ?? NSData()) as Data, encoding: String.Encoding.utf8))
                    
                    //!!!!!
//                    self.piccount += 1
//                    self.param.addEntries(from: [ "imageNumber" + String(self.piccount) : image! as UIImage])
//                    print("image" + String(self.piccount) + "added")
//                    print( "String(image.dynamicType) -> \(type(of: image))")

                
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
    
//    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
//        let retinaScale = UIScreen.main.scale
//        let retinaSquare = CGRect(origin: size * retinaScale, size: size * retinaScale)
//        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
//        let square = CGRectMake(0, 0, CGFloat(cropSizeLength), CGFloat(cropSizeLength))
//        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
//        
//        let manager = PHImageManager.default()
//        let options = PHImageRequestOptions()
//        var thumbnail = UIImage()
//        
//        options.isSynchronous = true
//        options.deliveryMode = .highQualityFormat
//        options.resizeMode = .exact
//        options.normalizedCropRect = cropRect
//        
//        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
//            thumbnail = result!
//        })
//        return thumbnail
//    }
    
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
        //assign checkbox delegate
        box.delegate = self
        //set story textView boarder color
        storytext.layer.borderColor = UIColor.lightGray.cgColor;
        storytext.layer.borderWidth = 0.5
        
        //6
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: Selector("Post"))
        self.navigationItem.rightBarButtonItem = rightBarButton
        // Changing the colour of the bar button items
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector("Cancel"))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
//        let width = ((collectionView!.frame.width) - leftAndRightPaddings) / numberOfItemsPerRRow
//        let layout = self.collectionView.collectionViewLayout as! UICollectionViewLayout
        //layout.itemSize = CGSizeMake(width, width + heightAjustment)
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
                    
                    //var imageData = UIImagePNGRepresentation(image!) as Data
                    //var imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    
                    //self.piccount += 1
                    //var imageString = "imageNumber" + String(count)
                    //self.param.addEntries(from: [ "imageNumber" + String(self.piccount) : image])
                    //print("image" + String(self.piccount))
                    
                }
            })
        }
        
        return cell!
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
//        
//        //cell.layer.cornerRadius = 50
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.borderWidth = 0.2
//
//        cell.storyImage.image = UIImage(named: images[indexPath.row])
//        cell.storyImage.contentMode = .scaleAspectFill
//        
//        return cell
    }

    
    //yao editted from here
    func didTap(_ checkBox: BEMCheckBox) {
        
        print("tapped!!\(checkBox.tag):\(checkBox.on)")
        agreetoshare = checkBox.on
        
    }
    
    //pass images and text to php
    func Post(){
        print(groupnametext.text! as String)
        print(agreetoshare)
        
<<<<<<< HEAD
        let request = NSMutableURLRequest(url: NSURL(string: "http://4900new.onebite.tk/update.php")! as URL)
=======
        let request = NSMutableURLRequest(url: NSURL(string: "http://localhost/~yao/volunteer/update.php")! as URL)
>>>>>>> 5eca6626743f4ab1be52d584ff9f67e42440373d
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
       // let imageData = UIImageJPEGRepresentation(UIImageView.image!, 0.5)
        
       // if(imageData==nil)  { return; }
        
//        let param = [
//            "groupnametext" : groupnametext.text! as String,
//            "reasontext" : reasontext.text! as String,
//            "actiontext" : actiontext.text! as String,
//            "storytext" : storytext.text! as String
//            
//        ] as NSMutableDictionary
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
    

}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
