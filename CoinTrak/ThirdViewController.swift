//
//  ThirdViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/17/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ThirdViewController: UIViewController, GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate {

    let data = Data.sharedInstance
    
    
    @IBOutlet weak var tickerField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    
    
    @IBOutlet weak var transactionTable: UITableView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var bannerView: GADBannerView!
    
    
    
    
    
    @IBAction func actionButton(sender: AnyObject) {
        balanceLabel.text = String(data.getBalanceFromCoin(tickerField.text!, address: addressField.text!))
        transactionTable.reloadData()
    }
    
    
    //Table View Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.getTransactionNumberFromCoin(tickerField.text!, address: addressField.text!)
    }
    
    //determine data in each cell individually by indexPath, using indexPath+1 as index for the data arrays
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TransactionCell
        
        //style make 0 margins for full seperator
        cell.layoutMargins = UIEdgeInsetsZero
        
        let (wasSent, amount) = data.getTransactionInfoFromCoinAndPlace(tickerField.text!, address: addressField.text!, transactionNumber: indexPath.row)
        
        if wasSent {
            cell.sentLabel.text = "sent"
        } else {
            cell.sentLabel.text = "recieved"
        }
        
        cell.amountLabel.text = String(amount)
        
        //returns the cell with inserted data
        return cell
    }
    
    //func for when a cell is selected, also allows for proper segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
        //updateDisplays()
    }

    
    //gets called if user taps anywhere
    @IBAction func tapAnywhere(sender: UITapGestureRecognizer) {
        view.endEditing(true) //close the keyboard!!
        
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
        
        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Block View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        
        
        
    }

    


}
