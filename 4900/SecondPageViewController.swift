//
//  FirstPageViewController.swift
//  4900
//
//  Created by leo  luo on 2017-05-16.
//  Copyright © 2017 leo  luo. All rights reserved.
//

import UIKit
import Foundation
import Photos
import AVKit
import DKImagePickerController
import OAuth2
import Alamofire
import SwiftyJSON

class SecondPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  SaveDataProtocol, BEMCheckBoxDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var box: BEMCheckBox!
    @IBOutlet weak var videoImgView: UIImageView!
    
    
    var agreetoshare = false
    var agreetosharestring = ""
    var piccount = 0
    
    let param = [
        "initialize" : "test"
        ] as NSMutableDictionary
    
    let pickerController = DKImagePickerController()
    var assets: [DKAsset]?
    
    var imagePickerController: UIImagePickerController? = nil
    
    var videoID: String = ""
    var videoData: NSData?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showImagePicker(_ sender: Any) {
        
        //the number of pics selecteds
        piccount = 0
        pickerController.assetType = .allPhotos
        pickerController.defaultSelectedAssets = self.assets
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.assets = assets
            
            // Yaoyao: Get UIImage data and send data to server
            // ps: use line 35 image variable
            for asset in self.assets! {
                asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                    let imageUI = image! as UIImage
                    self.piccount += 1
                    self.param.addEntries(from: [ "image" + String(self.piccount) : imageUI as UIImage])
                    //print("image" + String(self.piccount) + "added")
                })
            }
            
            self.collectionView?.reloadData()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(white: 0.9 , alpha: 1)
        self.navigationItem.title = "2/2"

        collectionView.delegate = self
        collectionView.dataSource = self
        
        //assign checkbox delegate
        box.delegate = self
        
        let cellWidth = ((UIScreen.main.bounds.width) - 32 - 30 ) / 3
        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        let rightBarButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecondPageViewController.post))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecondPageViewController.cancel))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
    }

    func didTap(_ checkBox: BEMCheckBox) {
        print("tapped yes\(checkBox.tag):\(checkBox.on)")
        agreetoshare = checkBox.on
                
    }
    
    
    func cancel() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func post(){
        //print("...\(name)...\(groupname)...\(date)...\(reason)...\(story)...")
        if checkValidation(){
            let accessToken = oauth2?.accessToken
            if self.videoData != nil {
                postVideoToYouTube(token: accessToken!, data: videoData!,callback: { success in
                    if success {
                        print ("callback in youtube upload1\(String(describing: self.videoID))")
                        self.postToServer()
                        //self.videoData = nil
                    }
                })
            } else {
                self.postToServer()
            }
        }
    }
    
    func postToServer(){
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://4900new.onebite.tk/update.php")! as URL)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if(agreetoshare){
            agreetosharestring = "true"
        }else{
            agreetosharestring = "false"
        }
        
        self.param.addEntries(from: ["groupnametext" : groupname])
        self.param.addEntries(from: ["reasontext" : reason])
        self.param.addEntries(from: ["actiontext" : name])
        self.param.addEntries(from: ["storytext" : story])
        self.param.addEntries(from: ["visitdate" : date])
        self.param.addEntries(from: ["videolink" : self.videoID])
        
        self.param.addEntries(from: ["agreetoshare" : agreetosharestring])
        self.param.addEntries(from: ["totalimage" : String(piccount) as String])
        
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            //print("******* response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            DispatchQueue.main.async {
            }
        }
        task.resume()
    }
    
    //check data validation and return to homepage
    func checkValidation() -> Bool{
        //check if all required fields are entered
        if name == "" || groupname == "" || date == "" {
            //unsuccessful post
            let alert = UIAlertController(title: "Oops", message: "Please fill in all required fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }else if datevalidation == "invalid" {
            let alert = UIAlertController(title: "Oops", message: "Invalid date input", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }else{
            //successful post
            let alert = UIAlertController(title: "Successful", message: "We have received your story \n Thank you! ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: finishpost))
            self.present(alert, animated: true, completion: nil)
            return true
        }

    }
    
    func finishpost(action: UIAlertAction){
        self.tabBarController?.selectedIndex = 0

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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("numberOfItemsInSection" + String(describing: self.assets?.count))
        return self.assets?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.assets![indexPath.row]
        var cell: UICollectionViewCell?
        var imageView: UIImageView?
        
        print("\n")
        print("indexPath = " + String(indexPath.row))
        
        if asset.isVideo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideo", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        }
        
//        if indexPath.row == self.assets?.count {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellUpload", for: indexPath)
//            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
//        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assets![indexPath.row]
        asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
            DispatchQueue.main.async(execute: { () in
                self.playVideo(avAsset!)
            })
        }
    }

    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    
    func saveData() {
        //print("second")
    }
    
    @IBAction func uploadVideo(_ sender: UIButton) {

        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": "173199618754-u8f3stkjt3d5n677mmuavl05juqsa8p3.apps.googleusercontent.com",
            "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://www.googleapis.com/oauth2/v3/token",
            "scope": "https://www.googleapis.com/auth/youtube.upload",     // depends on the API you use
            "redirect_uris": ["com.googleusercontent.apps.173199618754-u8f3stkjt3d5n677mmuavl05juqsa8p3:/oauth"],
            ])
        //oauth2?.logger = OAuth2DebugLogger(.debug)
        oauth2?.authorize() { authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
            }
            else {
                print("Authorization was canceled or went wrong: \(String(describing: error))")   // error will not be nil
            }
        }
        presentPicker()
    }
    
    func presentPicker(){
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.mediaTypes = ["public.movie"]
        self.present(imagePickerController!, animated: true, completion: nil)
    }
    
    //info dictionary contain the data
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoURL = info["UIImagePickerControllerMediaURL"] as? URL
        
        do {
            let asset = AVURLAsset(url: videoURL! , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            videoImgView.image = thumbnail
            // thumbnail here
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
                
        imagePickerController?.dismiss(animated: true, completion: nil)
        
        //print("\(String(describing: videoURL))")
        self.videoData = NSData(contentsOf: videoURL! as URL)
        
    }


    func postVideoToYouTube(token: String, data: NSData, callback: @escaping (Bool) -> Void){
        
        let headers = ["Authorization": "Bearer \(token)"]
        
        //let path = Bundle.mainBundle().pathForResource("video", ofType: "mp4")
        //let videodata: NSData = NSData.dataWithContentsOfMappedFile(path!)! as! NSData
        let videodata: NSData = data
        upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(videodata as Data, withName: "video", fileName: "video", mimeType: "application/octet-stream")
            },
            to: "https://www.googleapis.com/upload/youtube/v3/videos?part=id",
            headers: headers,
      
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON {  response in
                        //print("~~~~~~~~~~~~~~~!!!!!!!!\(response)")
                        if let  rawJSON = response.result.value {
                            let json = JSON(rawJSON)
                            for (key, subJSON) : (String, JSON) in json{
                                if key == "id"{
                                    self.videoID = subJSON.stringValue
                                }
                            }
                        }
                        callback(true)
                    }
                case .failure(_):
                    callback(false)
                }
        })
    }
    
}


extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
