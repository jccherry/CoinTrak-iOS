//
//  ContributeViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ContributeViewController: UIViewController, GADBannerViewDelegate {

    let data = Data.sharedInstance
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var bannerView: GADBannerView!
    
    @IBAction func githubButton(sender: AnyObject) {
        data.openURL("http://github.com/cointrak/cointrak-ios")
    }
    
    @IBAction func websiteButton(sender: AnyObject) {
        data.openURL("http://cointrak.me")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("Contribute View Controller Loaded")
        
        bannerView.adUnitID = "ca-app-pub-7526118464921133/4463426801"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)

        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

}
