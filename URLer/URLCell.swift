//
//  URLCell.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class URLCell: UITableViewCell {
    @IBOutlet var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        urlLabel.adjustsFontForContentSizeCategory = true
    }
}