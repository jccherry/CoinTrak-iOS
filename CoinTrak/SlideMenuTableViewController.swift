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
                self.performSegueWithIdentifier("donateSegue", sender: UITableViewCell.self)
                break
            
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling separator
        menuTable.layoutMargins = UIEdgeInsetsZero
        menuTable.separatorInset = UIEdgeInsetsZero
        
    }
    
}
