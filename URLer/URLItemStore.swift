//
//  URLItemStore.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class URLItemStore {
    var allItems = [URLItem]()
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("urlitems.archive")
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [URLItem] {
            allItems = archivedItems
        } else {
            for _ in 1...5 {
                print("RANDOM!!")
                let item = URLItem(random: true)
                allItems.append(item)
            }
        }
        print(allItems)
    }
    
    func removeItem(_ item: URLItem) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
            print("Item removed from itemStore")
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    @discardableResult func createItem() -> URLItem {
        let newItem = URLItem(random: true)
    
        allItems.append(newItem)
        return newItem
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
}
