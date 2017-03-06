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
    
    // MARK: - Variables and constants
    // variables
    @IBOutlet var messageLabel:UITextView!
    var messageLabelFont: UIFont?
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var codeStringValue: String = ""
    
    // constants
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
    let supportedIdentifiers = ["arcgis-explorer", "arcgis-navigator",
                                "argis-workforce", "arcgis-survey123", "arcgis-collector"]
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        messageLabelFont = messageLabel.font
        messageLabel.textAlignment = .center
        self.videoPreviewFrame()
        self.qrCodeFrame()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refreshScanController()
    }
    
    func refreshScanController() {
        captureSession?.startRunning()
        qrCodeFrameView?.frame = CGRect.zero
        let urlString = NSMutableAttributedString(string: "Scan valid ArcGIS URL")
        let attributedString = NSMutableAttributedString(string: urlString.string)
        messageLabel.attributedText = attributedString
        messageLabel.font = messageLabelFont
        messageLabel.textAlignment = .center
    }
    
    // MARK: - Class methods
    // start video preview frame
    func videoPreviewFrame() {
        // set-up cature device
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
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            // start capture session and move labels to front
            captureSession?.startRunning()
            view.bringSubview(toFront: messageLabel)
        } catch {
            // print errors thrown by AVCaptureDeviceInput
            print(error)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // recognize and place frame around code
    func qrCodeFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    // make sure app-id is supported
    func checkAppID(codeText code: String) -> Bool {
        let codeArray = code.characters.split {$0 == ":"}
        let app = codeArray.map(String.init)[0] // → ["arcgis-explorer", "//"]
        if supportedIdentifiers.contains(app), code != codeStringValue {
            return true
        } else {
            return false
        }
    }
    // delegate method to handle output
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects results: [Any]!, from connection: AVCaptureConnection!) {
        // check results
        if results == nil || results.count == 0 {
            if !codeStringValue.isEmpty {
                let attributedString = NSMutableAttributedString(string: codeStringValue)
                messageLabel.attributedText = attributedString
                messageLabel.font = messageLabelFont
                return
            } else {
                qrCodeFrameView?.frame = CGRect.zero
                let urlString = NSMutableAttributedString(string: "Code is not valid ArcGIS URL")
                let attributedString = NSMutableAttributedString(string: urlString.string)
                messageLabel.attributedText = attributedString
                messageLabel.font = messageLabelFont
                messageLabel.textAlignment = .center

                return
            }
        } else {
            // get first result
            let metadataObj = results[0] as! AVMetadataMachineReadableCodeObject
            print(metadataObj)
            print(metadataObj.type)
            // check to make sure supported type
            if supportedCodeTypes.contains(metadataObj.type) {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                // verify not empty or nil
                if !metadataObj.stringValue.isEmpty, checkAppID(codeText: metadataObj.stringValue){
                    captureSession?.stopRunning()
                    let attributedString = NSMutableAttributedString(string: metadataObj.stringValue)
                    messageLabel.attributedText = attributedString
                } else {
                    let urlString = NSMutableAttributedString(string: "Code is not valid ArcGIS URL")
                    let attributedString = NSMutableAttributedString(string: urlString.string)
                    messageLabel.attributedText = attributedString
                    messageLabel.font = messageLabelFont
                    messageLabel.textAlignment = .center

                }
                return
            }
        }
    }
    
    func saveCode(codeText code: String) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("ScanController will appear")
        refreshScanController()
    }
    
    
}
