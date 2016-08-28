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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //styling separator
        menuTable.layoutMargins = UIEdgeInsetsZero
        menuTable.separatorInset = UIEdgeInsetsZero
        
    }
    
}
