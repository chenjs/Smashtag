//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by chenjs on 15/2/27.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet {
            
//            tweetTextLabel?.text = tweet.text
//            if tweetTextLabel?.text != nil {
//                for _ in tweet.media {
//                    tweetTextLabel.text! += " 📷"
//                }
//            }
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: tweet.text)
            
            let hashtagAttrs = [NSForegroundColorAttributeName : UIColor.grayColor()]
            for hashtag in tweet.hashtags {
                attributedText.setAttributes(hashtagAttrs, range: hashtag.nsrange)
            }
            
            let urlAttrs = [NSForegroundColorAttributeName: UIColor.blueColor()]
            for url in tweet.urls {
                attributedText.setAttributes(urlAttrs, range: url.nsrange)
            }
            
            let userAttrs = [NSForegroundColorAttributeName: UIColor.brownColor()]
            for user in tweet.userMentions {
                attributedText.setAttributes(userAttrs, range: user.nsrange)
            }
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageUrl = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageUrl) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let image = UIImage(data: imageData) {
                                self.tweetProfileImageView?.image = image
                            }
                        })
                    }
                })
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            tweetTimeLabel.text = dateFormatter.stringFromDate(tweet.created)
        }
    }
}

