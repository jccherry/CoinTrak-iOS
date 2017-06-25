//
//  ThirdViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/17/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ThirdViewController: UIViewController, GADBannerViewDelegate {

    let data = Data.sharedInstance

    var timesViewDidAppear: Int = 0
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var bannerView: GADBannerView!
    
    //view one
    @IBOutlet var btcImage: UIImageView!
    @IBOutlet var btcBalance: UILabel!
    @IBOutlet var btcUSDLabel: UILabel!
    @IBOutlet var btcTextField: UITextField!
    @IBAction func btcButton(sender: AnyObject) {
    
        NSUserDefaults.standardUserDefaults().setObject(btcTextField.text, forKey: "btcAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            var btcBalanceNum: Double = 0.0
            btcBalanceNum = self.data.getBTCBalance(NSUserDefaults.standardUserDefaults().stringForKey("btcAddress")!)
            dispatch_async(dispatch_get_main_queue()) {
                self.btcBalance.text = String(btcBalanceNum)
                self.updateDisplays()
            }
        }
        
        //btcBalance.text = String(data.getBTCBalance(NSUserDefaults.standardUserDefaults().stringForKey("btcAddress")!))
    
    }
    
    //view two
    @IBOutlet var ethImage: UIImageView!
    @IBOutlet var ethBalance: UILabel!
    @IBOutlet var ethUSDLabel: UILabel!
    @IBOutlet var ethTextField: UITextField!
    @IBAction func ethButton(sender: AnyObject) {
    
        NSUserDefaults.standardUserDefaults().setObject(ethTextField.text, forKey: "ethAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
        //ethBalance.text = String(data.getETHBalance(NSUserDefaults.standardUserDefaults().stringForKey("ethAddress")!))
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            var ethBalanceNum: Double = 0.0
            ethBalanceNum = self.data.getETHBalance(NSUserDefaults.standardUserDefaults().stringForKey("ethAddress")!)
            dispatch_async(dispatch_get_main_queue()) {
                self.ethBalance.text = String(ethBalanceNum)
                self.updateDisplays()
            }
        }
    
    }
    
    //view three
    @IBOutlet var dogeImage: UIImageView!
    @IBOutlet var dogeBalance: UILabel!
    @IBOutlet var dogeUSDLabel: UILabel!
    @IBOutlet var dogeTextField: UITextField!
    @IBAction func dogeButton(sender: AnyObject) {
    
        NSUserDefaults.standardUserDefaults().setObject(dogeTextField.text, forKey: "dogeAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
        //dogeBalance.text = data.assessNumberStringFormat(data.getDOGEBalance(NSUserDefaults.standardUserDefaults().stringForKey("dogeAddress")!))
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            var dogeBalanceNum: Double = 0.0
            dogeBalanceNum = self.data.getDOGEBalance(NSUserDefaults.standardUserDefaults().stringForKey("dogeAddress")!)
            dispatch_async(dispatch_get_main_queue()) {
                self.dogeBalance.text = self.data.assessNumberStringFormat(dogeBalanceNum)
                self.updateDisplays()
            }
        }
        
    }
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
        updateDisplays()
    }

    
    //gets called if user taps anywhere
    @IBAction func tapAnywhere(sender: UITapGestureRecognizer) {
        view.endEditing(true) //close the keyboard!!
        
    }
    
    func updateDisplays() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //background thread
            
            //balance of addresses
            let btcBalanceNum = self.data.getBTCBalance(NSUserDefaults.standardUserDefaults().stringForKey("btcAddress")!)
            let ethBalanceNum = self.data.getETHBalance(NSUserDefaults.standardUserDefaults().stringForKey("ethAddress")!)
            let dogeBalanceNum = self.data.getDOGEBalance(NSUserDefaults.standardUserDefaults().stringForKey("dogeAddress")!)
            
            let btcUSD = btcBalanceNum * self.data.getCurrentPriceFromID("bitcoin")
            let ethUSD = ethBalanceNum * self.data.getCurrentPriceFromID("ethereum")
            let dogeUSD = dogeBalanceNum * self.data.getCurrentPriceFromID("dogecoin")
            
            //main queue (where u can update UI)
            dispatch_async(dispatch_get_main_queue()) {
                self.btcBalance.text = String(btcBalanceNum)
                self.ethBalance.text = String(ethBalanceNum)
                self.dogeBalance.text = self.data.assessNumberStringFormat(dogeBalanceNum)
                self.btcUSDLabel.text = self.data.formatMoneyString("$", amount: btcUSD, places: 2)
                self.ethUSDLabel.text = self.data.formatMoneyString("$", amount: ethUSD, places: 2)
                self.dogeUSDLabel.text = self.data.formatMoneyString("$", amount: dogeUSD, places: 2)
                
            }
        }
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("ad received")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("fail to receive ad with error: \(error.localizedDescription)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Wallet View Controller Loaded")
        
        
        //ad stuff
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-7526118464921133/9246833205"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //three ifs so that for the first time running an app, it doesnt crash and blank addresses are stored
        if NSUserDefaults.standardUserDefaults().stringForKey("btcAddress") == nil {
            print("No BTC Address, adding blank one")
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "btcAddress")
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey("ethAddress") == nil {
            print("No ETH Address, adding blank one")
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "ethAddress")
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey("dogeAddress") == nil {
            print("No DOGE Address, adding a blank one")
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "dogeAddress")
        }
        
        //set images
        btcImage.image = UIImage(named: "images/BTC.png")
        ethImage.image = UIImage(named: "images/ETH.png")
        dogeImage.image = UIImage(named: "images/DOGE.png")
        
        //set the text boxes to the stored addresses
        btcTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("btcAddress")
        ethTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("ethAddress")
        dogeTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("dogeAddress")

        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Wallet View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        updateDisplays()
        
        
        
        
    }

    


}
