//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by chenjs on 15/3/8.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController
{
    var searchItemList: SearchItemList!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItemList.count
    }

    private struct Constants {
        static let SearchItemIdentifier = "SearchItem"
        static let SegueSearchRecentIdentifier = "SearchRecent"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SearchItemIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = searchItemList.getSearchItem(indexPath.row)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            searchItemList.removeSearchItemAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueSearchRecentIdentifier:
                if let tvc = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        let indexPath = tableView.indexPathForCell(cell)!
                        tvc.searchItemList = searchItemList
                        tvc.searchText = searchItemList.getSearchItem(indexPath.row)
                        tvc.hidesBottomBarWhenPushed = true
                    }
                }
            default: break
            }
        }
    }
}
