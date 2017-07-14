//
//  DonateViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/14/17.
//  Copyright © 2017 John Chiaramonte. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {

    @IBAction func copyBTCButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "1F9wJhF6ZXhK6BKr8ReuMzEwtwggUGkri"
    }
    
    @IBAction func copyETHButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "0xa789e795e5b72b214ab6da93282a4669884f862e"
    }
    
    @IBAction func copyETCButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "0x8e362ef16a9fabb458a3a841685052a469a2c60c"
    }
    
    @IBAction func copyLTCButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "LhyMe2aPJm5vSP19oJByYHf1AvyzQ8Rgre"
    }
    
    @IBAction func copyZECButton(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = "t1XSD6fpXeeoy3LazZkFKJ7Kw4LAPPbjxze"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
