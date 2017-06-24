//
//  FourthViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/4/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //open shared instance of data class
    let data = Data.sharedInstance
    
    @IBOutlet var coinTable: UITableView!
    
    //info view stuff
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

    @IBOutlet var menuButton: UIBarButtonItem!
    
    
    //updates the data on the info view based on data and the selected cell
    func updateInfoDisplay(){
        
        //if the coin doesnt have an image give it the default one
        var imageLoc = "images/\(data.favoriteTickers[data.selectedFavoriteCell]).png"
        
        if UIImage(named: imageLoc) == nil {
            imageLoc = "images/defaultImage.png"
        }
        
        infoImage.image = UIImage(named: imageLoc)
        infoName.text = data.favoriteNames[data.selectedFavoriteCell]
        infoTicker.text = data.favoriteTickers[data.selectedFavoriteCell]
        
        infoChange1hr.text = data.formatPercentage(data.favoriteChange1hr[data.selectedFavoriteCell])
        infoChange24hr.text = data.formatPercentage(data.favoriteChange24hr[data.selectedFavoriteCell])
        infoChange7d.text = data.formatPercentage(data.favoriteChange7d[data.selectedFavoriteCell])
        
        infoMarketCap.text = data.assessNumberStringFormat(data.favoriteMarketCap[data.selectedFavoriteCell])
        infoVol24.text = data.assessNumberStringFormat(data.favoriteVolume[data.selectedFavoriteCell])
        infoSupply.text = data.assessNumberStringFormat(data.favoriteTotalSupply[data.selectedFavoriteCell])
    }
    
    //number of cells in the tableview is equal to data.tableCells, which is determined by the sliders in the SWRevealViewController menu
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return data.favoriteTickers.count
    }
    
    //determine data in each cell individually by indexPath, using indexPath+1 as index for the data arrays
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        //style make 0 margins for full seperator
        cell.layoutMargins = UIEdgeInsetsZero
        
        //default image set, will be changed if the coin has a specific picture
        cell.coinImage.image = UIImage(named: "images/defaultImage.png")
        
        //image path, must put the PNG images in image folder with the ticker in all caps ie: BTC.png
        var imageLoc = "images/\(data.favoriteTickers[indexPath.row]).png"
        
        if UIImage(named: imageLoc) == nil {
            imageLoc = "images/defaultImage.png"
        }
        
        //set image to the predetermined image Path
        cell.coinImage.image = UIImage(named: imageLoc)
        cell.name.text = data.favoriteNames[indexPath.row]
        cell.ticker.text = data.favoriteTickers[indexPath.row]
        cell.percent1hr.text = data.formatPercentage(data.favoriteChange1hr[indexPath.row])
        cell.price.text = "$\(data.favoritePrices[indexPath.row])"
        
        //change color on the percentage label in the cell based on pos/neg/0 percent change
        if data.favoriteChange1hr[indexPath.row] > 0{
            cell.percent1hr.textColor = UIColor.greenColor()
        } else if data.favoriteChange1hr[indexPath.row] < 0 {
            cell.percent1hr.textColor = UIColor.redColor()
        } else {
            cell.percent1hr.textColor = UIColor.blackColor()
        }
        
        
        //returns the cell with inserted data
        return cell
    }
    
    //delete button for favorites
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            if self.data.favoriteIdentifiers.count > 1 {
                print("Removing \(self.data.favoriteNames[indexPath.row]) from Favorites.")
                self.data.favoriteIdentifiers.removeAtIndex(indexPath.row)
                //print("after delete\(self.data.favoriteIdentifiers)")
                
                NSUserDefaults.standardUserDefaults().setObject(self.data.favoriteIdentifiers, forKey: "favoriteIdentifiers")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                
                self.data.favoriteSetup()
                self.data.initFavoriteArrays(self.data.favoriteIdentifiers.count)
                
                self.coinTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                //self.coinTable.reloadData()
                self.data.selectedFavoriteCell = 0
                self.updateInfoDisplay()
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            }

        })
        
        
        
        return [deleteAction]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if data.selectedFavoriteCell == indexPath.row{
            performSegueWithIdentifier("DetailSegue", sender: UITableViewCell())
            print("Double Tap! Segueing into Coin Detail View Controller")
        } else {
            print("Cell \(data.selectedFavoriteCell) Tapped (\(data.favoriteNames[indexPath.row]))")
        }
        
        data.selectedFavoriteCell = indexPath.row
        updateInfoDisplay()
        
    }
    
    //add refresh controll(spinny wheel when user pulls up on coinTable)
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FourthViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()

    //runs when user pulls up and the refresh wheel happens
    func handleRefresh(refreshControl: UIRefreshControl) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.initFavoriteArrays(self.data.favoriteIdentifiers.count)
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
        
        dateLabel.text = "Last Updated: \(data.stringTimeFromDate(data.favoritesUpdateDate))"
        
        self.refreshControl.addSubview(customView)
    }
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
    
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.initFavoriteArrays(self.data.favoriteIdentifiers.count)
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
                self.updateInfoDisplay()
                self.loadCustomRefreshView()
                self.coinTable.reloadData()
            }
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Favorites View Controller Loaded")
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //style the infoviewheader with border
        infoViewHeader.layer.borderColor = UIColor.blueColor().CGColor
        infoViewHeader.layer.borderWidth = 0.5
        
        //refresh control stuff
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        loadCustomRefreshView()
        coinTable.addSubview(self.refreshControl)
        
        //style the seperator by removing margins and spacing
        coinTable.layoutMargins = UIEdgeInsetsZero
        coinTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        coinTable.reloadData()
        
        //coinTable.rowHeight = coinTable.bounds.height / (7)
        
        updateInfoDisplay()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCustomRefreshView()
        
        //coinTable.reloadData()
        print()
        print("Favorites View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        data.tickerPageLoaded = false
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            self.data.initFavoriteArrays(self.data.favoriteIdentifiers.count)
            
            dispatch_async(dispatch_get_main_queue()) {
                //update the UI
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
