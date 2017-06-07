//
//  ScanController.swift
//  URLer
//
//  Created by Joel Whitney on 2/25/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: - variables/constants
    @IBOutlet var messageLabel: UITextView!
    var messageLabelFont: UIFont?
    var captureSession: AVCaptureSession?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var prevCodeStringvalue: String = ""
    var itemStore: URLItemStore {
        let navController = self.navigationController as? NavigationController
        return navController!.itemStore
    }
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    let supportedIdentifiers = Bundle.main.infoDictionary?["LSApplicationQueriesSchemes"] as? [String] ?? []
    
    // MARK: - actions
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refreshScanControllerState()
    }
    
    // MARK: - class methods
    func setMessageLabel(attributedString: NSMutableAttributedString) {
        messageLabel.attributedText = attributedString
        messageLabel.font = messageLabelFont
        messageLabel.textAlignment = .center
        messageLabel.isUserInteractionEnabled = false
        messageLabel.accessibilityIdentifier = "code_text"
    }
    func refreshScanControllerState() {
        captureSession?.startRunning()
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        qrCodeFrameView?.frame = CGRect.zero
        let urlString = NSMutableAttributedString(string: "Scan valid ArcGIS URL")
        setMessageLabel(attributedString: NSMutableAttributedString(string: urlString.string))
    }
    func capturePreviewFrame() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let captureRectWidth = CGFloat(150.0)
        let captureRectHeight = CGFloat(150.0)
        
        var cgCaptureRect = CGRect(x: (screenWidth / 2 - captureRectWidth / 2),
                                   y: (screenHeight / 2 - captureRectHeight / 2),
                                   width: captureRectWidth,
                                   height: captureRectHeight)
        
        let captureWindowView = UIView()
        captureWindowView.frame = cgCaptureRect
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // initialize the captureSession object and add input
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // initialize a output object to capture session
            let results = AVCaptureMetadataOutput()
            captureSession?.addOutput(results)
            results.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            results.metadataObjectTypes = supportedCodeTypes


            // initialize the video preview layer and add to view as sublayer
            capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            capturePreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(capturePreviewLayer!)
            
            // start capture session and move labels to front
            captureSession?.startRunning()
            view.bringSubview(toFront: messageLabel)
            
            // set capture area
            let captureRect = capturePreviewLayer?.metadataOutputRectOfInterest(for: cgCaptureRect)
            results.rectOfInterest = captureRect!
            captureWindowView.layer.backgroundColor = UIColor.clear.cgColor
            captureWindowView.layer.borderColor = UIColor.lightGray.cgColor
            captureWindowView.layer.borderWidth = 1
            view.addSubview(captureWindowView)
            view.bringSubview(toFront: captureWindowView)
            

        } catch {
            // print errors thrown by AVCaptureDeviceInput
            print("Error setting up preview frame: \(error)")
            return
        }
    }
    func captureDetectionFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.white.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    func verifyApplicationID(url: String) -> Bool {
        let urlSplit = url.characters.split {$0 == ":"}
        let app = urlSplit.map(String.init)[0] // → ["arcgis-explorer", "//"]
        if supportedIdentifiers.contains(app) {
            return true
        } else {
            return false
        }
    }
    func saveIntoRecents(url: URL) {
        var index = 0
        for item in itemStore.allItems {
            if item.url == url {
                itemStore.moveItem(fromIndex: index, to: 0)
                return
            }
            index += 1
        }
        itemStore.addItem(url: url)
    }
    
    // MARK: - delegate methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects results: [Any]!, from connection: AVCaptureConnection!) {
        if results == nil || results.count == 0 { // handle empty results
            qrCodeFrameView?.frame = CGRect.zero
            let urlString = NSMutableAttributedString(string: "Code is not valid ArcGIS URL")
            setMessageLabel(attributedString: NSMutableAttributedString(string: urlString.string))
            return
        } else {
            let metadataObj = results[0] as! AVMetadataMachineReadableCodeObject
            if supportedCodeTypes.contains(metadataObj.type) { // handle output type
                let barCodeObject = capturePreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                let urlString = metadataObj.stringValue.replacingOccurrences(of: " ", with: "")
                print(urlString)
                if !urlString.isEmpty, verifyApplicationID(url: urlString) { // handle result contents
                    captureSession?.stopRunning()
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    let attributedString = NSMutableAttributedString(string: urlString)
                    messageLabel.attributedText = attributedString
                    messageLabel.isUserInteractionEnabled = true
                    if UIApplication.shared.canOpenURL(URL(string: urlString)!) { // only save if app is installed
                        saveIntoRecents(url: URL(string: urlString)!)
                    }
                } else {
                    let noUrlString = NSMutableAttributedString(string: "Code is not valid ArcGIS URL")
                    setMessageLabel(attributedString: NSMutableAttributedString(string: noUrlString.string))
                }
                return
            }
        }
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

    // MARK: - view transition overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        messageLabelFont = messageLabel.font
        messageLabel.textAlignment = .center
        self.capturePreviewFrame()
        self.captureDetectionFrame()
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        print("ScanController will appear")
        navigationController?.setToolbarHidden(true, animated: true)
        checkInternalNetwork()
        refreshScanControllerState()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemStore.saveChanges()
    }
    
    
}
