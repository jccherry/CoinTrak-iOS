//
//  ContributeViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit

class ContributeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Contribute View Controller Loaded")

        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

}
