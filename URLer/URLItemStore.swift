//
//  URLItemStore.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class URLItemStore {
    // MARK: - variables/constants
    var allItems = [URLItem]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("urlitems.archive")
    }()
    
    // MARK: - initializers
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [URLItem] {
            print("Retrieving data from File System")
            allItems = archivedItems
        } else {
            print("No existing data -- creating random entries!!")
            for i in 0...5 {
                let item = URLItem(appIndex: i)
                allItems.append(item)
            }
        }
        print(allItems)
    }
    
    // MARK: - class methods
    func removeItem(_ item: URLItem) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
            print("Item removed from itemStore")
        }
    }
    func removeAllItems() {
        allItems = [URLItem]()
        saveChanges()
    }
    func moveItem(fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    func addItem(url: URL) {
        print("Adding \(url) to URLItemStore")
        let newItem = URLItem(url: url)
        allItems.insert(newItem, at: 0)
    }
    @discardableResult func createItem(url: URL) -> URLItem {
        let newItem = URLItem(url: url)
        allItems.append(newItem)
        return newItem
    }
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
}
