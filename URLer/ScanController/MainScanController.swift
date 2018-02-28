//
//  MainScanController.swift
//  URLer
//
//  Created by Joel Whitney on 2/27/18.
//  Copyright © 2018 Joel Whitney. All rights reserved.
//

import Foundation
import UIKit


protocol ScanControllerDelegate {
    func refreshScanControllerState(clearCurrentItem: Bool)
}

class MainScanController: SlidingPanelViewController, CurrentItemDelegate {

    var scanControllerDelegate: ScanControllerDelegate?
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        scanControllerDelegate?.refreshScanControllerState(clearCurrentItem: true)
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelPosition = .summary
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        DataStore.shared.currentItemDelegate = self
        scanControllerDelegate?.refreshScanControllerState(clearCurrentItem: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ScanController will appear")
        navigationController?.setToolbarHidden(true, animated: true)
        setDelegates()
        checkInternalNetwork()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DataStore.shared.saveChanges()
    }

    func currentItemUpdated() {
        print("mainScanController got updated current item")
        self.panelPosition = (DataStore.shared.currentItem != nil) ? .partial : .summary
        self.navigationItem.leftBarButtonItem?.isEnabled = (DataStore.shared.currentItem != nil) ? true : false
        setItem(DataStore.shared.currentItem)
    }
    
    func setDelegates() {
        guard let scanController = childViewControllers.first(where: { $0 is ScanController }) as? ScanController else {
        return
        }
        scanControllerDelegate = scanController
    }
    
    func setItem(_ item: URLItem?) {
        guard let scanControllerDetailsPanel = childViewControllers.first(where: { $0 is ScanControllerDetailsPanel }) as? ScanControllerDetailsPanel else {
                return
        }
        scanControllerDetailsPanel.currentItem = item
    }
    
    override var slidingPanelFullHeight: CGFloat {
        return super.slidingPanelFullHeight
    }
    
    override var slidingPanelPartialHeight: CGFloat {
        return super.slidingPanelPartialHeight
    }
    
    override func updateSlidingPanelPosition() {
        super.updateSlidingPanelPosition()
    }
    
    func checkInternalNetwork() {
        let serverName:String = "ekotest.esri.com"
        var numAddress:String = ""
        
        let host = CFHostCreateWithName(nil, serverName as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                numAddress = String(cString: hostname)
                print(numAddress)
            }
        }
        
        // if no access to appbuilder, only capature crash log, don't post
        if numAddress != "" {
            //  accessible to the server
            print("Great SUCCESS")
            self.navigationItem.leftBarButtonItems?[1].isEnabled = true
            self.navigationItem.leftBarButtonItems?[1].tintColor = UIColor.white
        } else {
            self.navigationItem.leftBarButtonItems?[1].isEnabled = false
            self.navigationItem.leftBarButtonItems?[1].tintColor = UIColor.clear
        }
    }
}
