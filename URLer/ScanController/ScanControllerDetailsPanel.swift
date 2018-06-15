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
    
    @IBOutlet weak var openURLButton: UIButton!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var badURLLabel: UILabel!
    @IBOutlet weak var badURLTextView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        disableButton()
    }
    
    func updateDetails() {
        if let currentItem = currentItem {
            urlTextView.text = currentItem.url.relativeString
            badURLLabel.text = ""
            badURLTextView.text = ""
            enableButton()
        } else {  // need to figure out error handling here
            urlTextView.text = ""
            badURLLabel.text = ""
            badURLTextView.text = ""
            disableButton()
        }
    }
    
    @objc func buttonPressed() {
        guard let url = currentItem?.url else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func buttonSetup() {
        openURLButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        openURLButton.setTitle("Scan QR Code with ArcGIS URL", for: .disabled)
        openURLButton.setTitleColor(#colorLiteral(red: 0.2433326922, green: 0.2457419267, blue: 0.2457419267, alpha: 1), for: .disabled)
        openURLButton.setTitle("Open ArcGIS URL", for: .normal)
        openURLButton.setTitleColor(#colorLiteral(red: 0.8991176902, green: 0.9080198455, blue: 0.9080198455, alpha: 1), for: .normal)
        openURLButton.layer.cornerRadius = 10
        openURLButton.layer.borderWidth = 1
    }
    
    func enableButton() {
        openURLButton.backgroundColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.9333333333, alpha: 1)
        openURLButton.layer.borderColor = #colorLiteral(red: 0.2433326922, green: 0.2457419267, blue: 0.2457419267, alpha: 1)
        openURLButton.isEnabled = true
    }
    
    func disableButton() {
        openURLButton.backgroundColor = #colorLiteral(red: 0.8357788706, green: 0.8357788706, blue: 0.8357788706, alpha: 1)
        openURLButton.layer.borderColor = #colorLiteral(red: 0.05930057282, green: 0.0598877072, blue: 0.0598877072, alpha: 1)
        openURLButton.isEnabled = false
    }
}
