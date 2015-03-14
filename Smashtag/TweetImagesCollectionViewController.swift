//
//  TweetImagesCollectionViewController.swift
//  Smashtag
//
//  Created by chenjs on 15/3/10.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit



class TweetImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    var imageTweets = [Tweet]()
    var tweets: [[Tweet]]? {
        didSet {
            if let allTweets = tweets {
                for tweetSection in allTweets {
                    for tweet in tweetSection {
                        if tweet.media.count > 0 {
                            imageTweets.append(tweet)
                        }
                    }
                }
            }
        }
    }
    
    var imagesCache: TweetImagesCache = TweetImagesCache() {
        didSet {
            imagesCache.name = "TweetImages"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        imagesCache.removeAll()
    }

    // MARK: UICollectionViewDataSource
    
    private struct Constants {
        static let TweetImageCellIdentifier = "Tweet Image Cell"
        static let SegueTweetDetail = "TweetDetail"
        static let BackBtnOfTweetDetailVC = "Images"
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageTweets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.TweetImageCellIdentifier, forIndexPath: indexPath) as TweetImageCollectionViewCell
    
        cell.imagesCache = self.imagesCache
        
        cell.backgroundColor = UIColor.blackColor()
        cell.imageURL = imageTweets[indexPath.row].media[0].url
    
        return cell
    }
    
    // MARK: UICollectionViewDelegateFowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    private let sectionInsets = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // MARK: Segue Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueTweetDetail:
                if let dvc = segue.destinationViewController as? TweetDetailViewController {
                    if let indexPath = collectionView?.indexPathForCell(sender! as UICollectionViewCell) {
                        dvc.tweet = imageTweets[indexPath.row]
                     
                        let backBtn = UIBarButtonItem(title: Constants.BackBtnOfTweetDetailVC,
                                                      style: UIBarButtonItemStyle.Plain,
                                                      target: nil,
                                                      action: nil)
                        self.navigationItem.backBarButtonItem = backBtn
                    }
                }
                break
            default:
                break
            }
            
        }
    }
    
}
