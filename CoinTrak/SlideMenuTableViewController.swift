//
//  SlideMenuTableViewController.swift
//  
//
//  Created by John Chiaramonte on 7/1/16.
//
//

import UIKit

class SlideMenuTableViewController: UITableViewController {
    
    let data = Data.sharedInstance
    
    //main table view for the view controller
    @IBOutlet var menuTable: UITableView!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("test", sender: UITableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling separator
        menuTable.layoutMargins = UIEdgeInsetsZero
        menuTable.separatorInset = UIEdgeInsetsZero
        
    }
    
}
