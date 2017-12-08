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
    
    @IBOutlet weak var adSwitchStatus: UISwitch!
    
    @IBAction func adSwitch(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(adSwitchStatus.on, forKey: "adsActivated")
    }
    
    @IBAction func donateSegueButton(sender: AnyObject) {
        self.performSegueWithIdentifier("donateSegue", sender: UIButton.self)
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("ad received")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("fail to receive ad with error: \(error.localizedDescription)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("Contribute View Controller Loaded")
        
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-7526118464921133/6293366807"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)

        adSwitchStatus.on = NSUserDefaults.standardUserDefaults().boolForKey("adsActivated")
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

}
