//
//  ScanControllerDetails.swift
//  URLer
//
//  Created by Joel Whitney on 2/27/18.
//  Copyright © 2018 Joel Whitney. All rights reserved.
//

import Foundation
import UIKit

class ScanControllerDetailsPanel: UIViewController, SlidingPanelContentProvider {
    var contentScrollView: UIScrollView?
    
    var currentItem: URLItem? {
        didSet {
            print("set currentItem on details panel")
            updateDetails()
        }
    }
    var summaryHeight: CGFloat = 130
    
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var badURLLabel: UILabel!
    @IBOutlet weak var badURLTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateDetails() {
        if let currentItem = currentItem {
            urlTextView.text = currentItem.url.relativeString
            badURLLabel.text = ""
            badURLTextView.text = ""
        } else {  // need to figure out error handling here
            urlTextView.text = ""
            badURLLabel.text = ""
            badURLTextView.text = ""
        }
    }
}
