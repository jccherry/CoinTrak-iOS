//
//  FirstViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 6/24/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //open shared data instance with the Data class
    let data = Data.sharedInstance
    
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
    
    
    //number of cells in the tableview is equal to data.tableCells, which is determined by the sliders in the SWRevealViewController menu
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.coinNames.count - 1 //-1 to account for usd as index position 0
    }

    //determine data in each cell individually by indexPath, using indexPath+1 as index for the data arrays
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        //style make 0 margins for full seperator
        cell.layoutMargins = UIEdgeInsetsZero
        
        //default image set, will be changed if the coin has a specific picture
        cell.coinImage.image = UIImage(named: "images/defaultImage.png")
        
        //image path, must put the PNG images in image folder with the ticker in all caps ie: BTC.png
        var imageLoc = "images/\(data.coinTickers[indexPath.row+1]).png"
        
        if UIImage(named: imageLoc) == nil {
            imageLoc = "images/defaultImage.png"
        }
        
        //set image to the predetermined image Path
        cell.coinImage.image = UIImage(named: imageLoc)
        
        
        
        //put data from data class into cells with index indexPath+1
            //always add 1 to exclude USD data
        cell.name.text = data.coinNames[indexPath.row+1]
        cell.ticker.text = data.coinTickers[indexPath.row+1]
        cell.price.text = "$\(data.coinPrices[indexPath.row+1])"
        
        //change color on the percentage label in the cell based on pos/neg/0 percent change
        if data.coinChange1hr[indexPath.row+1] > 0{
            cell.percent1hr.textColor = UIColor.greenColor()
        } else if data.coinChange1hr[indexPath.row+1] < 0 {
            cell.percent1hr.textColor = UIColor.redColor()
        } else {
            cell.percent1hr.textColor = UIColor.blackColor()
        }
        
        
        
        //actually put text into the text label for the
        cell.percent1hr.text = data.formatPercentage(data.coinChange1hr[indexPath.row+1])
        
        //returns the cell with inserted data
        return cell
    }

    //func for when a cell is selected, also allows for proper segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //if double tap, show CoinDetailViewController
        if data.selectedCell == indexPath.row+1 {
            performSegueWithIdentifier("DetailSegue", sender: UITableViewCell())
            print("Double Tap! Segueing into Coin Detail View Controller")
        } else {
            print("Cell \(data.selectedCell) Tapped (\(data.coinNames[indexPath.row+1]))")
        }
        
        //set the selected cell var in the data class for use in the CoinDetailViewController
        data.selectedCell = indexPath.row+1
        
        //update the display (no double tap needed)
        updateInfoDisplay()
        
        
 
        
    }
    
    //adds swipeable cells by being there
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            if !self.data.doesEqualStringInArray(self.data.coinIdentifiers[indexPath.row+1], array: self.data.favoriteIdentifiers){
                
                self.data.favoriteIdentifiers.append(self.data.coinIdentifiers[indexPath.row+1])
                print("Added \(self.data.coinNames[indexPath.row + 1]) to Favorites.")
            
                NSUserDefaults.standardUserDefaults().setObject(self.data.favoriteIdentifiers, forKey: "favoriteIdentifiers")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                
            } else {
                print("\(self.data.coinNames[indexPath.row+1]) is already in Favorites.")
            }
            
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
                self.updateInfoDisplay()
                
                if self.data.coinNames[1] == "" {
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
    func updateInfoDisplay(){
        
        //if the coin doesnt have an image give it the default one
        var imageLoc = "images/\(data.coinTickers[data.selectedCell]).png"
        
        if UIImage(named: imageLoc) == nil {
            imageLoc = "images/defaultImage.png"
        }
        
        infoImage.image = UIImage(named: imageLoc)
        infoName.text = data.coinNames[data.selectedCell]
        infoTicker.text = data.coinTickers[data.selectedCell]
        
        infoChange1hr.text = data.formatPercentage(data.coinChange1hr[data.selectedCell])
        infoChange24hr.text = data.formatPercentage(data.coinChange24hr[data.selectedCell])
        infoChange7d.text = data.formatPercentage(data.coinChange7d[data.selectedCell])
        
        infoMarketCap.text = data.assessNumberStringFormat(data.coinMarketCap[data.selectedCell])
        infoVol24.text = data.assessNumberStringFormat(data.coinVolume[data.selectedCell])
        infoSupply.text = data.assessNumberStringFormat(data.coinTotalSupply[data.selectedCell])
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
                
                self.updateInfoDisplay()
                self.loadCustomRefreshView()
                self.coinTable.reloadData()
            }
        }

        
    }
    
    //runs when the view loads in, not when it appears
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("~~~~~~~~~~~~~~~~~~~~~~Welcome to CoinTrak!~~~~~~~~~~~~~~~~~~~~~~")
        print()
        print()
        
        print("Ticker View Controller Loaded")
        
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
        
        //coinTable.rowHeight = coinTable.bounds.height
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //initialize the data arrays and update the data
            //i store only 100 coins by default, but using initArrays i can change that
        data.initArrays(100)
        //init the favorites arrays for the 4th view controller
        data.initFavoriteArrays(data.favoriteIdentifiers.count)
        
        
        //update the info display to the default, BTC
        updateInfoDisplay()
        
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
                self.coinTable.reloadData()
                self.updateInfoDisplay()
                
                if self.data.coinNames[1] == "" {
                    print("No Internet, No Coin Data")
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "No Internet, No Data", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                
                

                
            }
        
        }
        
    }
    

    
}

