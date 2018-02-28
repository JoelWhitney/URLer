//
//  ScanController.swift
//  URLer
//
//  Created by Joel Whitney on 2/25/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScanControllerDelegate {
    
    // MARK: - variables
    var captureSession: AVCaptureSession?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var prevCodeStringvalue: String = ""
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
    
    // MARK: - lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.capturePreviewFrame()
        self.captureDetectionFrame()
    }

    // MARK: - methods
    private func capturePreviewFrame() {
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
            
            // start capture session
            captureSession?.startRunning()
            
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
    
    private func captureDetectionFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.white.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    private func verifyApplicationID(url: String) -> Bool {
        let urlSplit = url.characters.split {$0 == ":"}
        let app = urlSplit.map(String.init)[0] // → ["arcgis-explorer", "//"]
        if supportedIdentifiers.contains(app) {
            return true
        } else {
            return false
        }
    }
    
    private func saveIntoRecents(url: URL) {
        var index = 0
        for item in DataStore.shared.allItems {
            if item.url == url {
                DataStore.shared.moveItem(fromIndex: index, to: 0)
                return
            }
            index += 1
        }
        DataStore.shared.addItem(url: url)
    }
    
    func refreshScanControllerState(clearCurrentItem: Bool) {
        if clearCurrentItem { DataStore.shared.currentItem = nil }
        captureSession?.startRunning()
        qrCodeFrameView?.frame = CGRect.zero
    }
    
    // MARK: - delegate methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects results: [Any]!, from connection: AVCaptureConnection!) {
        if results == nil || results.count == 0 { // handle empty results
            qrCodeFrameView?.frame = CGRect.zero
            // reset current item & handle error
            DataStore.shared.currentItem = nil
            return
        } else {
            let metadataObj = results[0] as! AVMetadataMachineReadableCodeObject
            if supportedCodeTypes.contains(metadataObj.type) { // handle output type
                let barCodeObject = capturePreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                let urlString = metadataObj.stringValue.replacingOccurrences(of: " ", with: "%20") // replace spaces to be safe
                if !urlString.isEmpty, verifyApplicationID(url: urlString), let validURL = URL(string: urlString) { // handle result contents
                    captureSession?.stopRunning()
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    DataStore.shared.currentItem = URLItem(url: validURL)
                    if UIApplication.shared.canOpenURL(validURL) { // only save if app is installed
                        saveIntoRecents(url: URL(string: urlString)!)
                    }
                } else {
                    // reset current item & handle error
                    DataStore.shared.currentItem = nil
                }
                return
            }
        }
    }
}
