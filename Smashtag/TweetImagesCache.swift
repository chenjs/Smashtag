//
//  TweetImagesCache.swift
//  Smashtag
//
//  Created by chenjs on 15/3/10.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class TweetImagesCache: NSCache
{
    override init() {
        super.init()
        totalCostLimit = 100 * 1024
    }
    
    func addImageWithURL(image: UIImage, url: NSURL, size: Int) {
        setObject(image, forKey: url, cost: size/1000)
    }
    
    func findImageWithURL(url: NSURL) -> UIImage? {
        return objectForKey(url) as? UIImage
    }
    
    func removeAll() {
        removeAllObjects()
    }
}
