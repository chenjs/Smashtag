//
//  TweetImageCollectionViewCell.swift
//  Smashtag
//
//  Created by chenjs on 15/3/10.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetImageCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imagesCache: TweetImagesCache?
    
    var imageURL: NSURL? {
        didSet {
            tweetImage = nil
            
            if let url = imageURL {
                spinner.stopAnimating()
                
                if let cachedImage = imagesCache?.findImageWithURL(url) {
                    self.tweetImage = cachedImage
                } else {
                
                    spinner?.startAnimating()
                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
                    dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                        let imageData = NSData(contentsOfURL: url)
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if imageData != nil {
                                let newImage = UIImage(data: imageData!)
                                self.tweetImage = newImage
                                
                                if newImage != nil {
                                    self.imagesCache?.addImageWithURL(newImage!, url: url, size: imageData!.length)
                                }
                            } else {
                                self.tweetImage = nil
                            }
                            self.spinner?.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    var tweetImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
}
