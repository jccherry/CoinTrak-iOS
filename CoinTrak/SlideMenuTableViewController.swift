//
//  SlideMenuTableViewController.swift
//  
//
//  Created by John Chiaramonte on 7/1/16.
//
//

import UIKit
import GoogleMobileAds

class SlideMenuTableViewController: UITableViewController, GADBannerViewDelegate {
    
    let data = Data.sharedInstance
    
    @IBOutlet var bannerView: GADBannerView!
    
    //main table view for the view controller
    @IBOutlet var menuTable: UITableView!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cellNum = indexPath.row
        
        switch cellNum{
            case 1:
                self.performSegueWithIdentifier("tickerSegue", sender: UITableViewCell.self)
                break
            
            case 2:
                self.performSegueWithIdentifier("aboutSegue", sender: UITableViewCell.self)
                break
            
            case 3:
                self.performSegueWithIdentifier("contributeSegue", sender: UITableViewCell.self)
                break
            
            case 4:
                self.performSegueWithIdentifier("contactSegue", sender: UITableViewCell.self)
                break
            
            default:
                break
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
        
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-7526118464921133/1863167208"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = data.testDevices
        bannerView.loadRequest(request)
        
        //styling separator
        menuTable.layoutMargins = UIEdgeInsetsZero
        menuTable.separatorInset = UIEdgeInsetsZero
        
    }
    
}
