//
//  TweetDetailViewController.swift
//  Smashtag
//
//  Created by chenjs on 15/3/5.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetDetailViewController: UITableViewController
{
    var tweet: Tweet? {
        didSet {
            if tweet != nil {
                tweetMentions.append(TweetMentions.Images(tweet!.media))
                tweetMentions.append(TweetMentions.Hashtags(tweet!.hashtags))
                tweetMentions.append(TweetMentions.UserMentions(tweet!.userMentions))
                tweetMentions.append(TweetMentions.Urls(tweet!.urls))
                
                title = "@" + tweet!.user.screenName
            }
        }
    }
    
    var searchTextOfSelected: String = ""
    
    private var tweetMentions = [TweetMentions]()
    
    private enum TweetMentions {
        case Images([MediaItem])
        case Hashtags([Tweet.IndexedKeyword])
        case UserMentions([Tweet.IndexedKeyword])
        case Urls([Tweet.IndexedKeyword])
        
        var count: Int {
            switch self {
            case .Images(let mediaItems): return mediaItems.count
            case .Hashtags(let hashtags): return hashtags.count
            case .UserMentions(let users): return users.count
            case .Urls(let urls): return urls.count
            }
        }
        
        var title: String {
            switch self {
            case .Images(let mediaItems): return mediaItems.count > 0 ? "Images" : ""
            case .Hashtags(let hashtags): return hashtags.count > 0 ? "Hashtags" : ""
            case .UserMentions(let users): return users.count > 0 ? "UserMentions" : ""
            case .Urls(let urls): return urls.count > 0 ? "URLS" : ""
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweetMentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetMentions[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetMentions[section].title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let media = tweet?.media[indexPath.row] {
                let width = tableView.bounds.size.width < CGFloat(media.width) ? tableView.bounds.size.width : CGFloat(media.width)
                let height = width / CGFloat(media.aspectRatio)
                return height
            } else {
                return 0
            }
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    private struct Constants {
        static let ImageCellIdentifier = "ImageCell"
        static let MentionCellIdentifier = "MentionCell"
        static let SegueIdentifierGoBack = "Go Back"
        static let SegueIdentifierShowImage = "Show Image"
        static let SegueIdentifierGotoURL = "Goto URL"
        static let BackBtnTitle = ""
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ImageCellIdentifier, forIndexPath: indexPath) as ImageTableViewCell
            
            cell.imageURL = tweet?.media[indexPath.row].url
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MentionCellIdentifier, forIndexPath: indexPath) as MentionTableViewCell
            
            if indexPath.section == 1 {
                cell.mentionText = tweet?.hashtags[indexPath.row].keyword
            } else if indexPath.section == 2 {
                cell.mentionText = tweet?.userMentions[indexPath.row].keyword
            } else if indexPath.section == 3 {
                cell.mentionText = tweet?.urls[indexPath.row].keyword
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            //println("selected is image")
            //performSegueWithIdentifier(Constants.SegueIdentifierShowImage, sender: indexPath)
            break
        case 1, 2:
            performSegueWithIdentifier(Constants.SegueIdentifierGoBack, sender: indexPath)
            break
        case 3:
            //openURLWithSafari(tweet!.urls[indexPath.row].keyword)
            performSegueWithIdentifier(Constants.SegueIdentifierGotoURL, sender: indexPath)
        default:
            break
        }
    }
    
    private func openURLWithSafari(urlString: String) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueIdentifierShowImage:
                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPathForCell(cell)!
                        
                    var destination = segue.destinationViewController as? UIViewController
                    if let nvc = destination as? UINavigationController {
                        destination = nvc.visibleViewController
                    }
                    
                    if let ivc = destination as? ImageViewController {
                        let imageCell = tableView.cellForRowAtIndexPath(indexPath) as ImageTableViewCell
                        if imageCell.tweetImage != nil {
                            ivc.image = imageCell.tweetImage
                        } else {
                            ivc.imageURL = imageCell.imageURL
                        }
                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.BackBtnTitle, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    }
                }
            case Constants.SegueIdentifierGoBack:
                if let indexPath = sender as? NSIndexPath {
                    if indexPath.section == 1 {
                        searchTextOfSelected = tweet!.hashtags[indexPath.row].keyword
                    } else if indexPath.section == 2 {
                        searchTextOfSelected = tweet!.userMentions[indexPath.row].keyword
                    }
                }
            case Constants.SegueIdentifierGotoURL:
                if let indexPath = sender as? NSIndexPath {
                    if let uvc = segue.destinationViewController as? TweetURLViewController {
                        uvc.urlString = tweet!.urls[indexPath.row].keyword
                    }
                }
            default:
                break
            }
        }
    }
}
