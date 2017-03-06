//
//  LastCell.swift
//  URLer
//
//  Created by Joel Whitney on 3/5/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class LastCell: UITableViewCell {
    @IBOutlet var lastCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lastCellLabel.adjustsFontForContentSizeCategory = true
    }

}
