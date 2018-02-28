//
//  MainViewController.swift
//  URLer
//
//  Created by Joel Whitney on 2/20/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchScreenViewController: UIViewController {
    // MARK: - variables
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPreviewFrame()
    }
    
    // MARK: - methods
    private func videoPreviewFrame() {
        let captureView = UIView()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // initialize the captureSession object and add input
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            // initialize the video preview layer and add to view as sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            captureView.layer.addSublayer(videoPreviewLayer!)
            // start capture session and move labels to front
            captureSession?.startRunning()
            view.addSubview(captureView)
            view.sendSubview(toBack: captureView)
        } catch {
            // print errors thrown by AVCaptureDeviceInput
            print("Error setting up preview frame: \(error)")
            return
        }
    }
    
    private func checkCameraPermissions() {  // ADD THIS TO THE BUTTON CLICK TO MAKE SURE ACCEPTED PERMISSONS
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            return
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true {
                    return
                } else {
                // User Rejected
                    self.checkCameraPermissions()
                }
            });
        }
    }
}

