//
//  AboutViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutViewController: UIViewController, GADBannerViewDelegate, UIWebViewDelegate {

    let data = Data.sharedInstance
    
    //bottom banner ad
    @IBOutlet var bannerView: GADBannerView!
    
    //menu button
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var webView: UIWebView!
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("ad received")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("fail to receive ad with error: \(error.localizedDescription)")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("Web View Starting Load...")
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        print("Web View Finished Load")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        print("WEB VIEW ERROR: \(error)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("About View Controller loaded")
        
        //gets rid of top buffer space on web view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //web view to display my website
        webView.delegate = self
        let url = NSURL (string: "http://www.cointrak.me")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        
        //ad things
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-7526118464921133/3339900404"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }

}
