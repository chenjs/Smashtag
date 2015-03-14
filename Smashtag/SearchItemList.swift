//
//  SearchItemList.swift
//  Smashtag
//
//  Created by chenjs on 15/3/8.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import Foundation

class SearchItemList
{
    private var itemList = [String]()
    
    init() {
        load()
    }
    
    var count: Int {
        get {
            return itemList.count
        }
    }
    
    func getSearchItem(index: Int) -> String? {
        if index < 0 || index >= itemList.count {
            return nil
        } else {
            return itemList[index]
        }
    }
    
    func addSearchItem(item: String) {
        if let index = find(itemList, item) {
            
        } else {
            itemList.insert(item, atIndex: 0)
            if itemList.count > 20 {
                itemList.removeLast()
            }
            save()
        }
    }
    
    func removeSearchItem(item: String) {
        if let index = find(itemList, item) {
            itemList.removeAtIndex(index)
            save()
        }
    }
    
    func removeSearchItemAtIndex(index: Int) {
        if index >= 0 && index < itemList.count {
            itemList.removeAtIndex(index)
            save()
        }
    }
    
    private struct Constants {
        static let ItemListKey = "ItemList Key"
    }
    
    private func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(itemList, forKey: Constants.ItemListKey)
        defaults.synchronize()
    }
    
    private func load() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let list = defaults.objectForKey(Constants.ItemListKey) as? [String] {
            itemList = list
        }
    }
}
