//
//  URLItem.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class URLItem: NSObject, NSCoding {
    // MARK: - variables/constants
    var url: URL
    let dateCreated: Date
    let itemKey: String
    
    // MARK: - initializers
    init(url: URL) {
        self.url = url
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        super.init()
    }
    convenience init(appIndex: Int) {
        let urls = ["arcgis-explorer://?", "arcgis-navigator://?", "arcgis-collector://?",
                    "arcgis-workforce://?", "arcgis-survey123://?", "arcgis-terzo://?"]
        if (appIndex > urls.count - 1) { // should probably just use revolving index so stay within array window
            print("Index is higher than number of items")
            self.init(url: URL(string: urls[0])!)
            return
        }
        self.init(url: URL(string: urls[appIndex])!)
    }
    required init(coder aDecoder: NSCoder) {
        url = aDecoder.decodeObject(forKey: "url") as! URL
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        super.init()
        
    }
    
    // MARK: - class methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
    }
}
