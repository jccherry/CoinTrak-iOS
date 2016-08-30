//
//  CoinDetailViewController.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/2/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts

class CoinDetailViewController: UIViewController {

    let data = Data.sharedInstance
    
    //chart views
    @IBOutlet var sixtyMinutesChart: LineChartView!
    @IBOutlet var twentyFourHourChart: LineChartView!
    @IBOutlet var thirtyDaysChart: LineChartView!
    @IBOutlet var oneYearChart: LineChartView!
    
    //parent view that the stack view, and all charts are in
    @IBOutlet var chartParentView: UIView!
    
    //info view header
    @IBOutlet var infoViewHeader: UIView!

    
    //info dislpay header elements
    @IBOutlet var infoName: UILabel!
    @IBOutlet var infoTicker: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    
    //info display stat elements
        //first column percentages
    @IBOutlet var infoChange1hr: UILabel!
    @IBOutlet var infoChange24hr: UILabel!
    @IBOutlet var infoChange7d: UILabel!
        //second column stats
    @IBOutlet var infoMarketCap: UILabel!
    @IBOutlet var infoVol24: UILabel!
    @IBOutlet var infoSupply: UILabel!
    
    @IBOutlet var loadingLoop: UIActivityIndicatorView!
    
    //update the info view on th ebottom of the page, identical to firstviewcontroller except it adds the priceLabel
    func updateInfoDisplay(){
        //set image as the default so that coins without the ticker image hava a default, and if they have an image, then it gets changed to that
        infoImage.image = UIImage(named: "image/defaultImage.png")
        
        var indexCell: Int = 1
        var localCoinNames: [String]
        var localCoinTickers: [String]
        var localChange1hr: [Double]
        var localChange24hr: [Double]
        var localChange7d: [Double]
        var localMarketCap: [Double]
        var localVolume: [Double]
        var localTotalSupply: [Double]
        var localPrices: [Double]
        
        if data.tickerPageLoaded {
            indexCell = data.selectedCell
            localCoinNames = data.coinNames
            localCoinTickers = data.coinTickers
            localChange1hr = data.coinChange1hr
            localChange24hr = data.coinChange24hr
            localChange7d = data.coinChange7d
            localMarketCap = data.coinMarketCap
            localVolume = data.coinVolume
            localTotalSupply = data.coinTotalSupply
            localPrices = data.coinPrices
        } else {
            indexCell = data.selectedFavoriteCell
            localCoinNames = data.favoriteNames
            localCoinTickers = data.favoriteTickers
            localChange1hr = data.favoriteChange1hr
            localChange24hr = data.favoriteChange24hr
            localChange7d = data.favoriteChange7d
            localMarketCap = data.favoriteMarketCap
            localVolume = data.favoriteVolume
            localTotalSupply = data.favoriteTotalSupply
            localPrices = data.favoritePrices
        }
        
        var imageLoc = "images/\(localCoinTickers[indexCell]).png"
        
        if UIImage(named: imageLoc) == nil {
            imageLoc = "images/defaultImage.png"
        }
        
        infoImage.image = UIImage(named: imageLoc)
        infoName.text = localCoinNames[indexCell]
        infoTicker.text = localCoinTickers[indexCell]
        
        infoChange1hr.text = data.formatPercentage(localChange1hr[indexCell])
        infoChange24hr.text = data.formatPercentage(localChange24hr[indexCell])
        infoChange7d.text = data.formatPercentage(localChange7d[indexCell])
        
        infoMarketCap.text = data.assessNumberStringFormat(localMarketCap[indexCell])
        infoVol24.text = data.assessNumberStringFormat(localVolume[indexCell])
        infoSupply.text = data.assessNumberStringFormat(localTotalSupply[indexCell])
        priceLabel.text = "$\(localPrices[indexCell])"
    }

    //set chart, dset data and display data
    func setChart(dataPoints: [NSDate], values: [Double], lineChartView: LineChartView, description: String) {
        
        //all data entries
        var dataEntries: [ChartDataEntry] = []
        
        //input y values
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: description)
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        
        //style the chart
        lineChartDataSet.colors = [NSUIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 200.0/255)]
        lineChartDataSet.fillColor = NSUIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 200.0/255)
        //lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.highlightLineWidth = 5
        lineChartDataSet.highlightColor = NSUIColor.lightGrayColor()
        lineChartDataSet.highlightEnabled = false
        //lineChartDataSet.axisDependency = .Left
        
        //set description text
        lineChartView.descriptionText = description
        
        //actually set the data
        lineChartView.data = lineChartData
        
        //lines slide in from left
        lineChartView.animate(xAxisDuration: 1.0)
        
        
        //set size make it the size of the full view in storyboard
        lineChartView.setViewPortOffsets(left: CGFloat(0), top: CGFloat(0), right: CGFloat(0), bottom: CGFloat(0))
        
        //let legend: ChartLegend = lineChartView.legend
        
        //let yAxis: ChartYAxis = lineChartView.leftAxis
    
        
    }
    
    
    //executes when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Coin Detail View Controller Loaded")
        
        infoViewHeader.layer.borderColor = UIColor.blueColor().CGColor
        infoViewHeader.layer.borderWidth = 0.5
        
        updateInfoDisplay()
        loadingLoop.startAnimating()
        
        //blank no data text
        sixtyMinutesChart.noDataText = ""
        twentyFourHourChart.noDataText = ""
        thirtyDaysChart.noDataText = ""
        oneYearChart.noDataText = ""
        
        //bring the loading loop to the front so user can see it
        chartParentView.bringSubviewToFront(loadingLoop)
        
    }
    
    //executes when view actually appears
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("Coin Detail View Controller appeared~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print()

        //this block of code allows data fetch to be performed in background so that i can still use the UI without the entire app being stalled
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //fetch data
            self.data.fillChartArrays()
            
            dispatch_async(dispatch_get_main_queue()) {
                //update UI
                
                //self.data.printChartDicts()
                
                //stop the activity indicator because the chart arrays are filled
                self.loadingLoop.stopAnimating()
                
                //set the charts!
                self.setChart(self.data.sixtyMinutesDates, values: self.data.sixtyMinutesPrices, lineChartView: self.sixtyMinutesChart, description: "1 Hour")
                self.setChart(self.data.twentyFourHoursDates, values: self.data.twentyFourHoursPrices, lineChartView: self.twentyFourHourChart,description: "24 Hours")
                self.setChart(self.data.thirtyDaysDates, values: self.data.thirtyDaysPrices, lineChartView: self.thirtyDaysChart,description: "30 Days")
                self.setChart(self.data.oneYearDates, values: self.data.oneYearPrices, lineChartView: self.oneYearChart, description: "1 Year")
            }
        }
        
        
        
        
        
    }

}
