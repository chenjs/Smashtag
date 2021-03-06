//
//  Functions.swift
//  MyLocations
//
//  Created by chenjs on 14/12/15.
//  Copyright (c) 2014年 TOMMY. All rights reserved.
//

import Foundation
import Dispatch


let applicationDocumentsDirectory: NSString = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
    return paths[0]
}()

func afterDelay(seconds: Double, closure: ()->()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}
