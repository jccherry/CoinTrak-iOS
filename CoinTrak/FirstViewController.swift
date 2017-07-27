//
//  FirstViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 6/24/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import SDWebImage

class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate, UISearchResultsUpdating{
    
    
    //open shared data instance with the Data class
    let data = Data.sharedInstance
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    //connect menu bar button
    @IBOutlet var menuButton: UIBarButtonItem!
    
    //info view header (with the symbol, pic, and name)
    @IBOutlet var infoViewHeader: UIView!
    
    //info dislpay header elements
    @IBOutlet var infoName: UILabel!
    @IBOutlet var infoTicker: UILabel!
    @IBOutlet var infoImage: UIImageView!
    
    //info display stat outlets
        //first column, percentages
    @IBOutlet var infoChange1hr: UILabel!
    @IBOutlet var infoChange24hr: UILabel!
    @IBOutlet var infoChange7d: UILabel!
        //second column, other stats
    @IBOutlet var infoMarketCap: UILabel!
    @IBOutlet var infoVol24: UILabel!
    @IBOutlet var infoSupply: UILabel!
    
    //main table view for the tickers
    @IBOutlet var coinTable: UITableView!
    
    //search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    //search controller "delegate" method
    func updateSearchResultsForSearchController(searchController: UISearchController){
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //number of cells in the tableview is equal to data.tableCells, which is determined by the sliders in the SWRevealViewController menu
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return data.filteredCoins.count
        }
        return data.coins.count - 1 //-1 to account for usd as index position 0
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        coinTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }

    //determine data in each cell individually by indexPath, using indexPath+1 as index for the data arrays
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        //style make 0 margins for full seperator
        cell.layoutMargins = UIEdgeInsetsZero
        
        let coin: Coin
        if searchController.active && searchController.searchBar.text != "" {
            coin = data.filteredCoins[indexPath.row]
        } else {
            coin = data.coins[indexPath.row+1]
        }
        
        cell.coinImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(coin.coinIdentifier).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        
        cell.name.text = coin.coinName
        cell.ticker.text = coin.coinTicker
        cell.price.text = "$\(coin.coinPrice)"
        
        if coin.coinChange1hr > 0{
            cell.percent1hr.textColor = UIColor.greenColor()
        } else if coin.coinChange1hr < 0 {
            cell.percent1hr.textColor = UIColor.redColor()
        } else {
            cell.percent1hr.textColor = UIColor.blackColor()
        }
        
        cell.percent1hr.text = data.formatPercentage(coin.coinChange1hr)
        
        //returns the cell with inserted data
        return cell
    }

    //func for when a cell is selected, also allows for proper segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        view.endEditing(true)
        
        let coin: Coin
        if searchController.active && searchController.searchBar.text != "" {
            coin = data.filteredCoins[indexPath.row]
        } else {
            coin = data.coins[indexPath.row+1]
        }
        
        data.selectedCoin = coin
        
        //if double tap, show CoinDetailViewController
        if data.selectedCell == indexPath.row+1 {
            performSegueWithIdentifier("DetailSegue", sender: UITableViewCell())
            print("Double Tap! Segueing into Coin Detail View Controller")
        } else {
            print("Cell \(data.selectedCell) Tapped (\(coin.coinName))")
        }
        
        //set the selected cell var in the data class for use in the CoinDetailViewController
        data.selectedCell = indexPath.row+1
        
        //update the display (no double tap needed)
        updateInfoDisplay(coin)
        
        
        
 
        
    }
    
    //adds swipeable cells by being there
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let coin: Coin
        if searchController.active && searchController.searchBar.text != "" {
            coin = data.filteredCoins[indexPath.row]
        } else {
            coin = data.coins[indexPath.row+1]
        }
        
        let favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            if !self.data.doesEqualStringInArray(coin.coinIdentifier, array: self.data.favoriteIdentifiers){
                
                self.data.favoriteIdentifiers.append(coin.coinIdentifier)
                print("Added \(self.data.coins[indexPath.row + 1].coinName) to Favorites.")
            
                NSUserDefaults.standardUserDefaults().setObject(self.data.favoriteIdentifiers, forKey: "favoriteIdentifiers")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                
            } else {
                print("\(coin.coinName) is already in Favorites.")
            }
            
            tableView.setEditing(false, animated: true)
            
            
        })
        

        
        return [favoriteAction]
    }
    
    //add refresh controll(spinny wheel when user pulls up on coinTable)
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FirstViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    //runs when user pulls up and the refresh wheel happens
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                self.data.selectedCoin = self.data.coins[self.data.selectedCell]
                self.updateInfoDisplay(self.data.selectedCoin)
                
                if self.data.coins[1].coinName == "" {
                    print("No Internet, No Coin Data")
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "No Internet, No Data", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
                self.coinTable.reloadData()
                self.loadCustomRefreshView()
                refreshControl.endRefreshing()
            }
        }
        
        
    }
    
    //loads cumstom refresh control view
    func loadCustomRefreshView(){
        
        //remove any and all subviews from the refreshView first, then add the new one
        for view in refreshControl.subviews {
            view.removeFromSuperview()
        }
        
        let refreshContents = NSBundle.mainBundle().loadNibNamed("refreshView", owner: self, options: nil)
        
        let customView = refreshContents![0] as! UIView
        
        customView.frame = refreshControl.bounds
        //customView.backgroundColor = UIColor(red: 222.0/255, green: 222.0/255, blue: 222.0/255, alpha: 1)
        
        let dateLabel = customView.viewWithTag(1) as! UILabel
        
        dateLabel.text = "Last Updated: \(data.stringTimeFromDate(data.dateUpdated))"
    
        self.refreshControl.addSubview(customView)
    }
    
    //updates the data on the info view based on data and the selected cell
    func updateInfoDisplay(coin: Coin){
        
        
        infoImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(coin.coinIdentifier).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        infoName.text = coin.coinName
        infoTicker.text = coin.coinTicker
        
        infoChange1hr.text = data.formatPercentage(coin.coinChange1hr)
        infoChange24hr.text = data.formatPercentage(coin.coinChange24hr)
        infoChange7d.text = data.formatPercentage(coin.coinChange7d)
        
        infoMarketCap.text = data.assessNumberStringFormat(coin.coinMarketCap)
        infoVol24.text = data.assessNumberStringFormat(coin.coinVolume)
        infoSupply.text = data.assessNumberStringFormat(coin.coinTotalSupply)
    }

    //top right refresh button
    @IBAction func refreshButton(sender: AnyObject) {
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                
                if self.data.coinNames[1] == "" {
                    print("No Internet, No Coin Data")
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "No Internet, No Data", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                self.data.selectedCoin = self.data.coins[self.data.selectedCell]
                self.updateInfoDisplay(self.data.selectedCoin)
                self.loadCustomRefreshView()
                self.coinTable.reloadData()
            }
        }

        
    }
    
    //search filtering
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        data.filteredCoins = data.coins.filter { coin in
            return coin.coinName.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        coinTable.reloadData()
    }

    
    //runs when the view loads in, not when it appears
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("~~~~~~~~~~~~~~~~~~~~~~Welcome to CoinTrak!~~~~~~~~~~~~~~~~~~~~~~")
        print()
        print()
        
        print("Ticker View Controller Loaded")
        
        coinTable.setContentOffset(CGPoint(x: 0,y: 10), animated: true)
        
        //configuring search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        coinTable.tableHeaderView = searchController.searchBar
        
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        infoViewHeader.layer.borderColor = UIColor.blueColor().CGColor
        infoViewHeader.layer.borderWidth = 0.5
        
        data.favoriteSetup()
        
        //refresh control stuff
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        loadCustomRefreshView()
        coinTable.addSubview(self.refreshControl)
        
        
        //style the seperator by removing margins and spacing
        coinTable.layoutMargins = UIEdgeInsetsZero
        coinTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        coinTable.rowHeight = coinTable.bounds.height / 24 + (coinTable.bounds.height/200)
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //initialize the data arrays and update the data
            //i store only 100 coins by default, but using initArrays i can change that
        data.initArrays(1000)
        //init the favorites arrays for the 4th view controller
        data.initFavoriteArrays(data.favoriteIdentifiers.count)
        
        data.selectedCoin = data.coins[1]
        //update the info display to the default, BTC
        updateInfoDisplay(data.selectedCoin)
        
        
    }
    
    
    //called every time view appears
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCustomRefreshView()
        
        data.tickerPageLoaded = true
        
        print()
        print("Ticker View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                self.data.selectedCoin = self.data.coins[self.data.selectedCell]
                self.coinTable.reloadData()
                self.updateInfoDisplay(self.data.selectedCoin)
                
                if self.data.coins[1].coinName == "" {
                    print("No Internet, No Coin Data")
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "Cannot Connect to the Internet.  Check your connection", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            }
        
        }
        
        
    }
    
}



