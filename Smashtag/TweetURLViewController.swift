//
//  TweetURLViewController.swift
//  Smashtag
//
//  Created by chenjs on 15/3/10.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetURLViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var urlString: String? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    func updateUI() {
        if urlString != nil {
            if let url = NSURL(string: urlString!) {
                let request = NSURLRequest(URL: url)
                webView?.loadRequest(request)
            }
        }
    }
}
