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

class PostStoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    private let leftAndRightPaddings: CGFloat = 8.0
    private let numberOfItemsPerRRow: CGFloat = 3.0
    private let heightAjustment: CGFloat = 30.0
    
    
    //1
    let pickerController = DKImagePickerController()
    var assets: [DKAsset]?
    
    //2
    @IBAction func showImagePicker(_ sender: Any) {
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            
            self.assets = assets
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
        
        
//        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: Selector("btnOpenCamera"))
//        self.navigationItem.rightBarButtonItem = camera
        
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
        //return images.count
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assets![indexPath.row]
        asset.fetchAVAssetWithCompleteBlock { (avAsset, info) in
            DispatchQueue.main.async(execute: { () in
                self.playVideo(avAsset!)
            })
        }
    }
    

}
