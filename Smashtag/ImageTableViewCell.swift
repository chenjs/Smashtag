//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by chenjs on 15/3/5.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var imageURL: NSURL? {
        didSet {
            if let url = imageURL {
                //println("imageURL: \(url)")
                
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: url)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if imageData != nil {
                            self.tweetImage = UIImage(data: imageData!)
                        } else {
                            self.tweetImage = nil
                        }
                    }
                }
            }
        }
    }
    
    var tweetImage: UIImage? {
        get {
            return tweetImageView.image
        }
        set {
            tweetImageView.image = newValue
        }
    }
}
