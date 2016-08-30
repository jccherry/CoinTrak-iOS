//
//  SecondViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 6/24/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextViewDelegate {

    let data = Data.sharedInstance
    
    //text boxes
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
   
    //price labels
    @IBOutlet weak var firstCoin: UILabel!
    @IBOutlet weak var secondCoin: UILabel!
    
    //record the last converted prices, to that if a user switches coins without switching values, it still converts
    var lastConvertedPriceFirst : Double = 0.0
    var lastConvertedPriceSecond : Double = 0.0
    
    //current coin values, will be changed as user enters into the text boxes and converts happen
    var firstCoinCurrent = 0.0
    var secondCoinCurrent = 0.0
    
    
    //menu Button
    @IBOutlet var menuButton: UIBarButtonItem!
    
    //ints to save which row is selected in each picker view
    var firstPickerRowSelected: Int = 1
    var secondPickerRowSelected: Int = 0
    
    
    //picker views
    @IBOutlet weak var firstCoinPicker: UIPickerView!
    @IBOutlet weak var secondCoinPicker: UIPickerView!

    
    //series of functions for the UIPickers
    
    //set outward label of each cell in the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data.coinTickers[row]
    }
    //number of options in the picker view, equal to convertcells var in data class, plus one for USD
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.coinPrices.count
    }
    //only one title in the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //what happens when an option is selected
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //the tags are for the left and right piker view, 1left 2right
        if pickerView.tag == 1{

            firstPickerRowSelected = row
            firstCoin.text = "$" + String(data.coinPrices[firstPickerRowSelected])
            
        } else {

            secondPickerRowSelected = row
            secondCoin.text = "$" + String(data.coinPrices[secondPickerRowSelected])
            
        }
        
    }
    
    



    @IBAction func convertButton(sender: UIButton) {
        convert()
    }
    
    func convert(){
        
        print("Converting...")
        
        //the reason that this conditional is cringingly long is so that because they were problems with extracting doubles from empty text boxes
        if (firstTextField.text != "" && Double(firstTextField.text!)! != firstCoinCurrent) || (firstTextField.text != "" && secondTextField.text == "") || ((data.coinPrices[firstPickerRowSelected] != lastConvertedPriceFirst || data.coinPrices[secondPickerRowSelected] != lastConvertedPriceSecond) && firstTextField.text != "") {
            
            //set the text fields value to the current value
            firstCoinCurrent = Double(firstTextField.text!)!
            
            //set the second value to the converted value based on the prices
            secondCoinCurrent = (firstCoinCurrent * data.coinPrices[firstPickerRowSelected]) / data.coinPrices[secondPickerRowSelected]
            
            //output the double to the other text box, with 6 decimals
            secondTextField.text = String(format: "%.6f", secondCoinCurrent)
            
            //make the coin's current value what u see on screen for accuracy
            secondCoinCurrent = Double(secondTextField.text!)!
            
        } else if (secondTextField.text != "" && Double(secondTextField.text!)! != secondCoinCurrent) || (secondTextField.text != "" && firstTextField.text == "") {
            
            secondCoinCurrent = Double(secondTextField.text!)!
            firstCoinCurrent = (secondCoinCurrent * data.coinPrices[secondPickerRowSelected]) / data.coinPrices[firstPickerRowSelected]
            firstTextField.text = String(format: "%.6f",firstCoinCurrent)
            firstCoinCurrent = Double(firstTextField.text!)!
            
        }
        
        //set the current prices to the last ones converted if a user switches the coin without switching values
        lastConvertedPriceFirst = data.coinPrices[firstPickerRowSelected]
        lastConvertedPriceSecond = data.coinPrices[secondPickerRowSelected]
        
    }
    
    //executes when user taps anywhere but the objects on the storyboard
    @IBAction func tapAnywhere(sender: UITapGestureRecognizer) {
        convert() //do a conversion with entered values
        view.endEditing(true) //close the keyboard!!
    }
    

    @IBAction func refreshButton(sender: AnyObject) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //reload all picker view components
                self.firstCoinPicker.reloadAllComponents()
                self.secondCoinPicker.reloadAllComponents()
                
                self.firstCoin.text = "$\(self.data.coinPrices[self.firstPickerRowSelected])"
                self.secondCoin.text = "$\(self.data.coinPrices[self.secondPickerRowSelected])"
            }
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Converter View Controller Loaded")
        
        //gesture recognizer to open reveal view controller
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //reload all picker view components by default
        firstCoinPicker.reloadAllComponents()
        secondCoinPicker.reloadAllComponents()
        
        //set up menu button
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //load the coin prices into the text by default (it doesnt by default)
        firstCoin.text = "$" + String(data.coinPrices[firstPickerRowSelected])
        secondCoin.text = "$" + String(data.coinPrices[secondPickerRowSelected])
        
        //set the tags of each picker so that i can distinguish
        firstCoinPicker.tag = 1
        secondCoinPicker.tag = 2
        
        
        //select row one with BTC as default for the second picker
        firstCoinPicker.selectRow(1, inComponent: 0, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Converter View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //refresh data
            self.data.refreshData()
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                self.firstCoinPicker.reloadAllComponents()
                self.secondCoinPicker.reloadAllComponents()
                
                self.firstCoin.text = "$\(self.data.coinPrices[self.firstPickerRowSelected])"
                self.secondCoin.text = "$\(self.data.coinPrices[self.secondPickerRowSelected])"
            }
        }
    }
    
    

}

