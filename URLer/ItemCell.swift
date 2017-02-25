//
//  ItemCell.swift
//  URLer
//
//  Created by Joel Whitney on 2/21/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var url: UILabel!
    @IBOutlet var appImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        url.adjustsFontForContentSizeCategory = true
    }
    
}
