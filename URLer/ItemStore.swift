////
////  ItemStore.swift
////  URLer
////
////  Created by Joel Whitney on 2/21/17.
////  Copyright © 2017 Joel Whitney. All rights reserved.
////
//
//import UIKit
//
//class ItemStore {
//    var allItems = [Item]()
//    let itemArchiveURL: URL = {
//        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent("items.archive")
//    }()
//    
////    init() {
////        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
////            allItems = archivedItems
////        } else{
////            for _ in 0..<5 {
////                createItem()
////            }
////        }
////    }
//    init() {
//        for _ in 0..<5 {
//            createItem()
//        }
//    }
//    
//    func removeItem(_ item: Item) {
//        if let index = allItems.index(of: item) {
//            allItems.remove(at: index)
//        }
//    }
//    
//    func moveItem(from fromIndex: Int, to toIndex: Int) {
//        if fromIndex == toIndex {
//            return
//        }
//        let movedItem = allItems[fromIndex]
//        allItems.remove(at: fromIndex)
//        allItems.insert(movedItem, at: toIndex)
//    }
//    
//    @discardableResult func createItem() -> Item {
//        let newItem = Item(random: true)
//        
//        allItems.append(newItem)
//        
//        return newItem
//    }
//    
//    func saveChanges() -> Bool {
//        print("Saving items to: \(itemArchiveURL.path)")
//        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
//    }
//}
