//
//  AboutController.swift
//  URLer
//
//  Created by Joel Whitney on 3/12/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class AboutController: UITableViewController {
    
    let version: String? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String?
    let build: String? = Bundle.main.infoDictionary!["CFBundleVersion"] as! String?

    @IBOutlet var buildLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    
    // MARK: - view transition overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = version
        buildLabel.text = build
        navigationItem.title = "About"
    }
}
