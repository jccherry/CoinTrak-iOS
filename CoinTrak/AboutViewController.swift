//
//  AboutViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutViewController: UIViewController, GADBannerViewDelegate {

    let data = Data.sharedInstance
    
    //bottom banner ad
    @IBOutlet var bannerView: GADBannerView!
    
    //menu button
    @IBOutlet var menuButton: UIBarButtonItem!
    
    //coinMarketCap link
    @IBAction func cmcButton(sender: UIButton) {
        data.openURL("http://coinmarketcap.com")
    }
    //cryptocompare link
    @IBAction func cryptoCompButton(sender: UIButton) {
        data.openURL("http://cryptocompare.com")
    }
    //blockchain.info link
    @IBAction func blockChainButton(sender: UIButton) {
        data.openURL("http://blockchain.info")
    }
    //etherchain.org link
    @IBAction func etherChainButton(sender: UIButton) {
        data.openURL("http://etherchain.org")
    }
    //dogechain.info link
    @IBAction func dogeChainButton(sender: UIButton) {
        data.openURL("http://dogechain.info")
    }
    //icons8 link
    @IBAction func iconsEightButton(sender: UIButton) {
        data.openURL("http://icons8.com")
    }
    
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("ad received")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("fail to receive ad with error: \(error.localizedDescription)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("About View Controller loaded")
        
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
