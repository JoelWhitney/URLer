//
//  URLItem.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class URLItem: NSObject, NSCoding {
    var url: URL
    let dateCreated: Date
    let itemKey: String
    
    init(url: URL) {
        self.url = url
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let urls = ["arcgis-explorer://", "arcgis-navigator://", "arcgis-collector://",
                        "arcgis-workforce://", "arcgis-survey123://"]
            let idx = arc4random_uniform(UInt32(urls.count))
            let randomURL = URL(string: urls[Int(idx)])
            self.init(url: randomURL!)
        } else {
            self.init(url: URL(string: "")!)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        url = aDecoder.decodeObject(forKey: "url") as! URL
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
    }
}
