//
//  AboutViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("About View Controller loaded")
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }

}
