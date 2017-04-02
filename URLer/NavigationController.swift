//
//  NavigationController.swift
//  URLer
//
//  Created by Joel Whitney on 3/6/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var itemStore = URLItemStore()
    
    let navBarAppearance = UINavigationBar.appearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarAppearance.isTranslucent = true
        navBarAppearance.barTintColor = UIColor.init(colorLiteralRed: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 0.5)
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.toolbar.isTranslucent = true
        self.toolbar.barTintColor = UIColor.init(colorLiteralRed: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 0.5)
        self.toolbar.tintColor = UIColor.white
    }
}
