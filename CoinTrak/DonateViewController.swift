//
//  DonateViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 8/30/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Donate View Controller Loaded")
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }


}
