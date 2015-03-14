//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by chenjs on 15/2/27.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var searchItemList: SearchItemList!
    
    var tweets = [[Tweet]]()
    var searchText: String? = "#stanford" {
        didSet {
            //println("searchText = \(searchText)")
            
            lastSuccessfulRequest = nil
            
            tweets.removeAll()
            tableView.reloadData()
            
            searchTextField.text = searchText
            refresh()
            
            if searchText != nil {
                searchItemList.addSearchItem(searchText!)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest?.requestForNewer
        }
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        
        refresh(refreshControl)
    }

    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        //println("fetched tweets: \(newTweets.count)")
                        
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchTextField.resignFirstResponder()
            searchText = searchTextField.text
        }
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }
    
    private struct Storyboard {
        static let TweetReuseIdentifier: String = "Tweet"
        static let SegueTweetDetailIdentifier: String = "TweetDetail"
        static let SegueShowTweetImagesIdentifier: String = "ShowTweetImages"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell

        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueTweetDetailIdentifier:
                if let dvc = segue.destinationViewController as? TweetDetailViewController {
                    if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                        dvc.tweet = tweets[indexPath.section][indexPath.row]
                        
                        let backBtn = UIBarButtonItem(title: searchText, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                        self.navigationItem.backBarButtonItem = backBtn
                    }
                }
            case Storyboard.SegueShowTweetImagesIdentifier:
                if let icvc = segue.destinationViewController as? TweetImagesCollectionViewController {
                    icvc.tweets = self.tweets
                    icvc.title = "Images"
                }
            default:
                break
            }
        }
    }

    @IBAction func goBack(segue: UIStoryboardSegue) {
        if let dvc = segue.sourceViewController as? TweetDetailViewController {
            //println("goBack, selected searchText = \(dvc.searchTextOfSelected)")
            self.searchText = dvc.searchTextOfSelected
        }
    }
}
