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

class CoinDetailViewController: UIViewController, ChartViewDelegate {

    let data = Data.sharedInstance
    
    @IBOutlet weak var navBar: UINavigationItem!
    
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
    //basically updates the local arrays with either the total coin info from the data instance or the favorites coin data from data instance. see data.tickerPageLoaded
    func updateInfoDisplay(coin: Coin){
        
        infoImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(coin.coinIdentifier).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
        infoName.text = coin.coinName
        infoTicker.text = coin.coinTicker
        
        infoChange1hr.text = data.formatPercentage(coin.coinChange1hr)
        infoChange24hr.text = data.formatPercentage(coin.coinChange24hr)
        infoChange7d.text = data.formatPercentage(coin.coinChange7d)
        
        infoMarketCap.text = data.assessNumberStringFormat(coin.coinMarketCap)
        infoVol24.text = data.assessNumberStringFormat(coin.coinVolume)
        infoSupply.text = data.assessNumberStringFormat(coin.coinTotalSupply)
        
        priceLabel.text = "$\(coin.coinPrice)"
        
        /*
        var indexCell: Int = 1
        
        if data.tickerPageLoaded{
            indexCell = data.selectedCell
            infoImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(data.coins[indexCell].coinIdentifier).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
            infoName.text = data.coins[indexCell].coinName
            infoTicker.text = data.coins[indexCell].coinTicker
            
            infoChange1hr.text = data.formatPercentage(data.coins[indexCell].coinChange1hr)
            infoChange24hr.text = data.formatPercentage(data.coins[indexCell].coinChange24hr)
            infoChange7d.text = data.formatPercentage(data.coins[indexCell].coinChange7d)
            
            infoMarketCap.text = data.assessNumberStringFormat(data.coins[indexCell].coinMarketCap)
            infoVol24.text = data.assessNumberStringFormat(data.coins[indexCell].coinVolume)
            infoSupply.text = data.assessNumberStringFormat(data.coins[indexCell].coinTotalSupply)
            
            priceLabel.text = "$\(data.coins[indexCell].coinPrice)"
            
        } else {
            indexCell = data.selectedFavoriteCell
            infoImage.sd_setImageWithURL(NSURL(string: "http://files.coinmarketcap.com.s3-website-us-east-1.amazonaws.com/static/img/coins/128x128/\(data.favoriteIdentifiers[indexCell]).png"),placeholderImage: UIImage(named: "CoinTrakLogo"))
            infoName.text = data.favoriteNames[indexCell]
            infoTicker.text = data.favoriteTickers[indexCell]
            
            infoChange1hr.text = data.formatPercentage(data.favoriteChange1hr[indexCell])
            infoChange24hr.text = data.formatPercentage(data.favoriteChange24hr[indexCell])
            infoChange7d.text = data.formatPercentage(data.favoriteChange7d[indexCell])
            
            infoMarketCap.text = data.assessNumberStringFormat(data.favoriteMarketCap[indexCell])
            infoVol24.text = data.assessNumberStringFormat(data.favoriteVolume[indexCell])
            infoSupply.text = data.assessNumberStringFormat(data.favoriteTotalSupply[indexCell])
            
            priceLabel.text = "$\(data.favoritePrices[indexCell])"
        }
        */
        
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
        
        
        
        //style the chart
        lineChartDataSet.colors = [NSUIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 200.0/255)]
        lineChartDataSet.fillColor = NSUIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 200.0/255)
        //lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.highlightLineWidth = 4.5
        lineChartDataSet.highlightColor = UIColor(red: 0.0/255.0, green: 102.0/255.0, blue: 1.0, alpha: 150.0/255)
        lineChartDataSet.highlightEnabled = true
        //lineChartDataSet.axisDependency = .Left

        lineChartView.delegate = self
        
        //set description text
        lineChartView.descriptionText =  ""
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        //actually set the data
        lineChartView.data = lineChartData
        
        //lines slide in from left
        lineChartView.animate(xAxisDuration: 1.0)
        
        lineChartView.doubleTapToZoomEnabled = false
        //set size make it the size of the full view in storyboard
        lineChartView.setViewPortOffsets(left: CGFloat(0), top: CGFloat(0), right: CGFloat(0), bottom: CGFloat(0))
        
        
        //let legend: ChartLegend = lineChartView.legend
        
        //let yAxis: ChartYAxis = lineChartView.leftAxis
    
        
    }
    
    
    //chartView Delegate Methods
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        chartView.descriptionText = String("$\(entry.value)")
    }
    
    //executes when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Coin Detail View Controller Loaded")
        
        infoViewHeader.layer.borderColor = UIColor.blueColor().CGColor
        infoViewHeader.layer.borderWidth = 0.5
        
        updateInfoDisplay(data.selectedCoin)
        loadingLoop.startAnimating()
        
        navBar.title = infoName.text
        
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
