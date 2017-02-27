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
    @IBOutlet var topbar: UIView!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
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
    let supportedIdentifiers = ["arcgis-explorer", "arcgis-navigator", "argis-workforce", "arcgis-survey123", "arcgis-collector"]
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoPreviewFrame()
        self.qrCodeFrame()
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
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            // initialize the video preview layer and add to view as sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            // start capture session and move labels to front
            captureSession?.startRunning()
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
        } catch {
            // print errors thrown by AVCaptureDeviceInput
            print(error)
            return
        }
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
    // delegate method to handle output
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputresults results: [Any]!, from connection: AVCaptureConnection!) {
        // check results
        if results == nil || results.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            let urlString = NSMutableAttributedString(string: "No valid code is detected")
            let attributedString = NSMutableAttributedString(string: urlString.string)
            messageLabel.attributedText = attributedString
            return
        }
        // get first result
        let metadataObj = results[0] as! AVMetadataMachineReadableCodeObject
        print(metadataObj)
        print(metadataObj.type)
        // check to make sure supported type
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            // verify not empty or nil
            if metadataObj.stringValue != nil, !metadataObj.stringValue.isEmpty {
                guard let attributedString = checkAppID(codeText: metadataObj.stringValue) else {
                    return
                }
                // Format textView
//                let linkAttributes = [ NSForegroundColorAttributeName: UIColor.red.cgColor]
//                messageLabel.linkTextAttributes = linkAttributes
                // Assign url to textView
                messageLabel.dataDetectorTypes = .link
                messageLabel.isEditable = false
                messageLabel.attributedText = attributedString
            }
        }
    }
    // make sure app-id is supported
    func checkAppID(codeText code: String) -> NSMutableAttributedString? {
        let codeArray = code.characters.split {$0 == ":"}
        let app = codeArray.map(String.init)[0] // → ["arcgis-explorer", "//"]
        if supportedIdentifiers.contains(app) {
            return NSMutableAttributedString(string: code)
        } else {
            return nil
        }
    }
}
