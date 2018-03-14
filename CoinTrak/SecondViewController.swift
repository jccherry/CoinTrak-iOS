//
//  SecondViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 6/24/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController, UITextViewDelegate, GADBannerViewDelegate {

    let data = Data.sharedInstance
    
    //ad banner
    @IBOutlet var bannerView: GADBannerView!
    
    //text boxes
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
   
    //price labels
    @IBOutlet weak var firstCoin: UILabel!
    @IBOutlet weak var secondCoin: UILabel!
    @IBOutlet weak var conversionRateLabel: UILabel!
    
    //images
    @IBOutlet weak var firstCoinImage: UIImageView!
    @IBOutlet weak var secondCoinImage: UIImageView!
    
    //coin buttons
    @IBOutlet weak var firstCoinButtonOutlet: UIButton!
    @IBAction func firstCoinButton(sender: AnyObject) {
        data.isFirstCoinSelected = true
        self.performSegueWithIdentifier("chooseConvertSegue", sender: UIButton.self)
    }
    
    @IBOutlet weak var secondCoinButtonOutlet: UIButton!
    @IBAction func secondCoinButon(sender: AnyObject) {
        data.isFirstCoinSelected = false
        self.performSegueWithIdentifier("chooseConvertSegue", sender: UIButton.self)
    }
    
    //record the last converted prices, to that if a user switches coins without switching values, it still converts
    var lastConvertedPriceFirst : Double = 0.0
    var lastConvertedPriceSecond : Double = 0.0
    
    //current coin values, will be changed as user enters into the text boxes and converts happen
    var firstCoinCurrent = 0.0
    var secondCoinCurrent = 0.0
    
    
    //menu Button
    @IBOutlet var menuButton: UIBarButtonItem!
    
    

    @IBAction func convertButton(sender: UIButton) {
        convert()
    }
    
    func convert(){
        
        print("Converting...")
        
        //replace instances of commas in each string with periods (for that one guy who emailed me)
        firstTextField.text = firstTextField.text?.stringByReplacingOccurrencesOfString(",", withString: ".")
        secondTextField.text = secondTextField.text?.stringByReplacingOccurrencesOfString(",", withString: ".")

        
        //the reason that this conditional is cringingly long is so that because they were problems with extracting doubles from empty text boxes and crashes happened
        if (firstTextField.text != "" && Double(firstTextField.text!)! != firstCoinCurrent) || (firstTextField.text != "" && secondTextField.text! == "") || ((data.firstCoin.coinPrice != lastConvertedPriceFirst || data.secondCoin.coinPrice != lastConvertedPriceSecond) && firstTextField.text != ""){
            
            //set the text fields value to the current value
            firstCoinCurrent = Double(firstTextField.text!)!
            
            //set the second value to the converted value based on the prices
            secondCoinCurrent = (firstCoinCurrent * data.firstCoin.coinPrice) / data.secondCoin.coinPrice
            
            //output the double to the other text box, with 6 decimals
            secondTextField.text = String(format: "%.6f", secondCoinCurrent)
            
            //make the coin's current value what u see on screen for accuracy
            secondCoinCurrent = Double(secondTextField.text!)!
            
        } else if (secondTextField.text != "" && Double(secondTextField.text!)! != secondCoinCurrent) || (secondTextField.text != "" && firstTextField.text! == ""){
            
            secondCoinCurrent = Double(secondTextField.text!)!
            firstCoinCurrent = (secondCoinCurrent * data.secondCoin.coinPrice) / data.firstCoin.coinPrice
            firstTextField.text = String(format: "%.6f",firstCoinCurrent)
            firstCoinCurrent = Double(firstTextField.text!)!
            
        }
        
        //set the current prices to the last ones converted if a user switches the coin without switching values
        lastConvertedPriceFirst = data.firstCoin.coinPrice
        lastConvertedPriceSecond = data.secondCoin.coinPrice
        
    }
    
    //executes when user taps anywhere but the objects on the storyboard
    @IBAction func tapAnywhere(sender: UITapGestureRecognizer) {
        convert() //do a conversion with entered values
        view.endEditing(true) //close the keyboard!!
    }
    
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("ad received")
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("fail to receive ad with error: \(error.localizedDescription)")
    }
    

    
    //updates the UI with coin info and convert
    func setActiveCoins() {
        firstCoin.text = "$\(data.firstCoin.coinPrice)"
        secondCoin.text = "$\(data.secondCoin.coinPrice)"
        
        conversionRateLabel.text = "1 \(data.firstCoin.coinTicker) = \(String(format: "%.8f",(data.firstCoin.coinPrice/data.secondCoin.coinPrice))) \(data.secondCoin.coinTicker)"
        
        firstCoinButtonOutlet.setTitle(data.firstCoin.coinTicker, forState: .Normal)
        secondCoinButtonOutlet.setTitle(data.secondCoin.coinTicker, forState: .Normal)
        
        firstCoinImage.sd_setImageWithURL(NSURL(string: "https://raw.githubusercontent.com/cjdowner/cryptocurrency-icons/master/128/color/\(data.firstCoin.coinTicker.lowercaseString).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        
       // https://raw.githubusercontent.com/cjdowner/cryptocurrency-icons/master/128/color/\(data.favoriteTickers[data.selectedFavoriteCell].lowercaseString).png
        
        secondCoinImage.sd_setImageWithURL(NSURL(string: "https://raw.githubusercontent.com/cjdowner/cryptocurrency-icons/master/128/color/\(data.secondCoin.coinTicker.lowercaseString).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        convert()
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Converter View Controller Loaded")
        
        //ad stuff
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-7526118464921133/7770100007"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
        //load coin objects into memory (BTC and USD) (i don't update them in viewDidLoad() load assuming that the user has already loaded initial data from the first view controller)
        data.firstCoin = data.coins[1]
        data.secondCoin = data.coins[0]
        setActiveCoins()
        

        
        //set up menu button
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Converter View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                /*
                self.data.selectedCoin = self.data.coins[self.data.selectedCell]
                
                if self.data.coins[1].coinName == "" {
                    print("No Internet, No Coin Data")
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "Cannot Connect to the Internet.  Check your connection", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                 */
                //self.data.firstCoin = self.data.coins[1]
                //self.data.secondCoin = self.data.coins[0]
                self.setActiveCoins()
            }
            
        }

        
        

    }
    
    

}

