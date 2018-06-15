//
//  AppDelegate.swift
//  URLer
//
//  Created by Joel Whitney on 2/20/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        print("Continue User Activity called: ")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            //handle url and open whatever page you want to open.
            let alertController = UIAlertController(title: "URLer Called Upon", message: url.absoluteString ?? "", preferredStyle: .alert)
            let dismissAlert = UIAlertAction(title: "Dismiss", style: .default, handler: { UIAlertAction in
                if let presentedVC = (self.window?.rootViewController?.presentedViewController as? ScanController) {
                    presentedVC.refreshScanControllerState(clearCurrentItem: false)
                }
            })
            
            alertController.addAction(dismissAlert)
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        var message = ""
        // handle query parameters
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            // display each queryItem in alert message
            for item in queryItems {
                message += "\(item.name)=\(String(describing: item.value!))\n"
            }
        } else {
            message = "Opened without message"
        }
        // make alert
        let alertController = UIAlertController(title: "URLer Called Upon", message: message, preferredStyle: .alert)
        let dismissAlert = UIAlertAction(title: "Dismiss", style: .default, handler: { UIAlertAction in
            if let presentedVC = (self.window?.rootViewController?.presentedViewController as? ScanController) {
                presentedVC.refreshScanControllerState(clearCurrentItem: false)
            }
        })
        alertController.addAction(dismissAlert)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // should I be doing something here to save on close
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh therotte user interface.
        if let navController = self.window?.rootViewController as? UINavigationController, let scanController = (navController.presentedViewController as? ScanController) {
            
            guard DataStore.shared.currentItem != nil else { return }
            
            scanController.refreshScanControllerState(clearCurrentItem: true)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

