//
//  DataFinderController.swift
//  URLer
//
//  Created by Joel Whitney on 5/8/17.
//  Copyright © 2017 Joel Whitney. All rights reserved.
//

import UIKit
import WebKit

class DataFinderController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var toolbar: UIToolbar!
    var back: UIBarButtonItem!
    var forward: UIBarButtonItem!
    let progressSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let progressBar = UIProgressView(progressViewStyle: .bar)
    
    var itemStore: URLItemStore {
        let navController = self.navigationController as? NavigationController
        return navController!.itemStore
    }
    let supportedIdentifiers = Bundle.main.infoDictionary?["LSApplicationQueriesSchemes"] as? [String] ?? []
    var starting_url = URL(string:"https://ekotest.esri.com/datafinder?app=Explorer")
    //var starting_url = URL(string:"https://appbuilder.esri.com/ios")
    //var starting_url = URL(string:"https://www.google.com/")
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
    
    func back(sender: UIBarButtonItem) {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
        back.isEnabled = webView.canGoBack
        forward.isEnabled = webView.canGoForward
    }
    
    func forward(sender: UIBarButtonItem) {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        }
        back.isEnabled = webView.canGoBack
        forward.isEnabled = webView.canGoForward
    }
    
    func webView(webView: WKWebView, navigation: WKNavigation, withError error: NSError) {
        progressSpinner.stopAnimating()
        progressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: { self.progressBar.alpha = 0 }, completion: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alert:UIAlertController = UIAlertController(title: "Error", message: "Could not load webpage", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let urlSplit = url!.absoluteString.characters.split {$0 == ":"}
        let app = urlSplit.map(String.init)[0] // → ["arcgis-explorer", "//"]
        print("url = \(url!)")
        if supportedIdentifiers.contains(app) {
            let urlString = url?.absoluteString.replacingOccurrences(of: " ", with: "")
            let newUrl = URL(string: urlString!)
            if UIApplication.shared.canOpenURL(newUrl!) {
                saveIntoRecents(url: newUrl!)
                if UIApplication.shared.canOpenURL(newUrl!){
                    UIApplication.shared.openURL(newUrl!)
                }
                decisionHandler(.allow)
            } else {
                // throw some error
                print("Bad new url")
                let alertController = UIAlertController(title: "Error", message: "Application schema is not valid or application not installed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: {
                    decisionHandler(.cancel)
                })
            }
        } else {
            decisionHandler(.allow)
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
    
    func closeWebview(){
        //dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        print("WebView start loading.")
        progressSpinner.startAnimating()
        back.isEnabled = webView.canGoBack
        forward.isEnabled = webView.canGoForward
        self.progressBar.setProgress(0, animated: true)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { self.progressBar.alpha = 1 }, completion: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation){
        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        print("WebView content loaded.")
        progressSpinner.stopAnimating()
        progressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: { self.progressBar.alpha = 0 }, completion: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        webView.frame = CGRect(x: 0, y: 22, width: view.frame.width, height: view.frame.height-66)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        
        toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: view.frame.height-44, width: view.frame.width, height: 44)
        progressBar.frame = CGRect(x: 0, y: toolbar.frame.maxY-2, width: view.frame.width, height: 4)
        toolbar.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleWidth]
        
        progressSpinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        progressBar.alpha = 0
        progressBar.tintColor = UIColor.blue
        progressBar.autoresizingMask = .flexibleWidth
        
        let progress = UIBarButtonItem(customView: progressSpinner)
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(DataFinderController.closeWebview))
        close.imageInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        close.tintColor = UIColor.white
        
        back = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: self, action: #selector(DataFinderController.back(sender:)))
        back.imageInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        back.tintColor = UIColor.white
        
        forward = UIBarButtonItem(image: #imageLiteral(resourceName: "Forward"), style: .plain, target: self, action: #selector(DataFinderController.forward(sender:)))
        forward.imageInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        forward.tintColor = UIColor.white
        
        back.isEnabled = false
        forward.isEnabled = false
        
        toolbar.setItems([close, flex, back, progress, forward], animated: true)
        toolbar.barTintColor = UIColor.black
        toolbar.barStyle = UIBarStyle.black
        
        view.addSubview(progressBar)
        view.addSubview(toolbar)
        view.bringSubview(toFront: progressBar)
        
        let url = starting_url
        let req = URLRequest(url: url!)
        
        
        webView.load(req)
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
                                    print(html ?? "nothing here")
        })
        print("DataFinderController loaded its view.")
        

    }
    
}
