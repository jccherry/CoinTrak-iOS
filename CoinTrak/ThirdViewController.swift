//
//  ThirdViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/17/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON

class ThirdViewController: UIViewController, GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let data = Data.sharedInstance
    var json:JSON = JSON(data: NSData())
    
    var tickerArray = ["BTC", "ETH", "LTC"]
    var identifierArray = ["bitcoin","ethereum","litecoin"]
    
    var selectedRow:Int = 0
    
  
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var usdBalanceLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var transactionTable: UITableView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var bannerView: GADBannerView!
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tickerArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addressField.text = ""
        balanceLabel.text = "Coin Balance"
        usdBalanceLabel.text = "$0.0"
        json = JSON(data: NSData())
        selectedRow = row
        transactionTable.reloadData()
    }
    
    @IBAction func actionButton(sender: AnyObject) {
        //balanceLabel.text = String(data.getBalanceFromCoin(tickerField.text!, address: addressField.text!))
        
        
        let urlString:String = "https://api.blockcypher.com/v1/\(tickerArray[selectedRow].lowercaseString)/main/addrs/\(addressField.text!)?token=53fadb28f590427e8854197595feb95a"
        
        print(urlString)
        
        if let url = NSURL(string: urlString){
            if let data = try? NSData(contentsOfURL: url, options: []){
                json = JSON(data: data)
            }
        }
        
        //divide by this power of ten to get the number reported by the api into the actual number, different for each currency
        
        var placesDown: Double = 10
        
        switch selectedRow{
        case 0:
            placesDown = 100000000
            break
        case 1:
            placesDown = 1000000000000000000
            break
        case 2:
            placesDown = 1000000000
            break
        default: break
        }
        
        balanceLabel.text = "\(String(format: "%.8f", json["final_balance"].doubleValue / placesDown)) \(tickerArray[selectedRow])"
        
        usdBalanceLabel.text = "$\(String(format: "%.2f", (json["final_balance"].doubleValue / placesDown) * data.getCurrentPriceFromID(identifierArray[selectedRow])))"
        
        transactionTable.reloadData()
    }
    
    
    //Table View Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data.getTransactionNumberFromCoin(tickerField.text!, address: addressField.text!)
        return json["final_n_tx"].intValue
    }
    
    //determine data in each cell individually by indexPath, using indexPath+1 as index for the data arrays
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TransactionCell
        
        //style make 0 margins for full seperator
        cell.layoutMargins = UIEdgeInsetsZero
        
        //var to see whether the transaction was sent or recieved
        var wasSent:Bool = false
        
        //json api has this as an int
        
        var sentStatus: Int = 0
        
        if json["txrefs"].arrayValue[indexPath.row] != nil {
            sentStatus = json["txrefs"].arrayValue[indexPath.row]["tx_input_n"].intValue
            
            
            //interpret the int and change the value of the bool accordingly
            if sentStatus == 0 {
                wasSent = true
            } else {
                wasSent = false
            }
            
            //get amount
            let amount:Double = json["txrefs"].arrayValue[indexPath.row]["value"].doubleValue
            
            
            //change the cell's labels and things
            if wasSent {
                cell.sentLabel.text = "Sent"
            } else {
                cell.sentLabel.text = "Recieved"
            }
            
            
            var placesDown: Double = 10
            switch selectedRow{
            case 0:
                placesDown = 100000000
                break
            case 1:
                placesDown = 1000000000000000000
                break
            case 2:
                placesDown = 1000000000
                break
            default: break
            }
            
            cell.amountLabel.text = String(format: "%.8f", amount / placesDown) + " \(tickerArray[selectedRow])"
            
            
            cell.usdLabel.text = "$" + String(format: "%.2f", (amount / placesDown) * data.getCurrentPriceFromID(identifierArray[selectedRow]))
            
            print(String(data.getCurrentPriceFromID(identifierArray[selectedRow])))

        } else {
            let alertController = UIAlertController(title: "No Confirmed Transactions", message: "Wait a few minutes for confirmations", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            cell.sentLabel.text = ""
            cell.amountLabel.text = ""
            cell.usdLabel.text = ""
        }
        
        
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
        
        print("Block Explorer View Controller Loaded")
        
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
        
        //style the tableview
        transactionTable.layoutMargins = UIEdgeInsetsZero
        transactionTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        //transactionTable.separatorColor = UIColor.blueColor()
        
        
        
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Block View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        
        
        
    }

    


}
