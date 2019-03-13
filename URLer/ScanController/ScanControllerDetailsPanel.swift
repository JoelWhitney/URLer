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
            updateDetails()
        }
    }
    var summaryHeight: CGFloat = 130
    
    @IBOutlet weak var openURLButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentScrollView = tableView
        tableView.tableFooterView = UIView()
        buttonSetup()
        disableButton()
    }
    
    func updateDetails() {
        if let currentItem = currentItem {
            tableView.reloadData()
            enableButton()
        } else {  // need to figure out error handling here
            tableView.reloadData()
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

// MARK: - tableView data source
extension ScanControllerDetailsPanel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.currentItem != nil else { return 0 }
        return 3
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int) -> String {
        switch section {
        case 0:
            return "URL"
        case 1:
            return "Scheme"
        default:
            return "Query items"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentItem = self.currentItem, let components = URLComponents(url: currentItem.url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return queryItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath) as! URLCell
        guard let currentItem = self.currentItem, let components = URLComponents(url: currentItem.url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return cell }
        
        switch indexPath.section {
        case 0:
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath) as! URLCell
            cell.urlLabel.text = currentItem.url.relativeString
            return cell
        case 1:
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "SchemeCell", for: indexPath) as! SchemeCell
            
            cell.schemeLabel.text = (components.scheme != nil) ? components.scheme! + "://" : ""
            return cell
        default:
            let queryItem = queryItems[indexPath.row]
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "QueryItemCell", for: indexPath) as! QueryItemCell
            cell.paramLabel.text = queryItem.name
            cell.valueLabel.text = queryItem.value ?? ""
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 44.0
//        case 1:
//            return 44.0
//        default:
//            return 65.0
//        }
//    }
}


// MARK: - tableView delegate
extension ScanControllerDetailsPanel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

// MARK: - tableView cell
class URLCell: UITableViewCell {
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SchemeCell: UITableViewCell {
    @IBOutlet weak var schemeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class QueryItemCell: UITableViewCell {
    @IBOutlet weak var paramLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
