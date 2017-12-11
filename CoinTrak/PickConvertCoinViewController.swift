//
//  PickConvertCoinViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 12/10/17.
//  Copyright © 2017 John Chiaramonte. All rights reserved.
//

import Foundation
import UIKit

class PickConvertCoinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating{
    
    let data = Data.sharedInstance
    
    
    @IBOutlet weak var convertTable: UITableView!
    
    //search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    //search controller "delegate" method
    func updateSearchResultsForSearchController(searchController: UISearchController){
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //search filtering
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        data.filteredCoins = data.coins.filter { coin in
            return coin.coinName.lowercaseString.containsString(searchText.lowercaseString) || coin.coinTicker.lowercaseString.containsString(searchText.lowercaseString)
            // the or allows for searching of both names and tickers simultaneouslyx
        }
        
        convertTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return data.filteredCoins.count
        }
        return data.coins.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var currentCoin:Coin
        if searchController.active && searchController.searchBar.text != "" {
            currentCoin = data.filteredCoins[indexPath.row]
            if data.isFirstCoinSelected{
                
                data.firstCoin = currentCoin
            } else {
                
                data.secondCoin = currentCoin
            }
            //dissmiss the search controller
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            currentCoin = data.coins[indexPath.row]
            if data.isFirstCoinSelected{
                
                data.firstCoin = currentCoin
            } else {
                
                data.secondCoin = currentCoin
            }
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ConvertCoinCell
        
        let currentCoin: Coin
        if searchController.active && searchController.searchBar.text != "" {
            currentCoin = data.filteredCoins[indexPath.row]
        } else {
            currentCoin = data.coins[indexPath.row]
        }
        
        cell.coinImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(currentCoin.coinIdentifier).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        cell.nameLabel.text = currentCoin.coinName
        cell.tickerLabel.text = currentCoin.coinTicker
        cell.priceLabel.text = "$\(currentCoin.coinPrice)"
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuring search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        convertTable.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
