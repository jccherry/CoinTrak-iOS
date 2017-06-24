//
//  Data.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 6/24/16.
//  Copyright © 2016 John Chiaramonte. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import GoogleMobileAds

class Data {

    static let sharedInstance = Data()
    init(){}
    
    //let testDevices: [AnyObject] = ["a602ccfafd871943181aea6dc7401ddf",kGADSimulatorID]
    let testDevices: [AnyObject] = []
    
    //Coin data variable arrays
    var coinNames: [String] = []
    var coinTickers: [String] = []
    var coinIdentifiers: [String] = []
    var coinPrices:[Double] = []
    var coinChange1hr:[Double] = []
    var coinChange24hr:[Double] = []
    var coinChange7d: [Double] = []
    var coinTotalSupply: [Double] = []
    var coinMarketCap: [Double] = []
    var coinVolume: [Double] = []
    
    //var that determines how many coins' data is stored
    var totalPlaces: Int = 10
    
    //current tapped cell in main ticker table
    var selectedCell: Int = 1
    var selectedFavoriteCell: Int = 0
    
    //arrays for chart
    var sixtyMinutesDates : [NSDate] = []
    var twentyFourHoursDates : [NSDate] = []
    var thirtyDaysDates : [NSDate] = []
    var oneYearDates : [NSDate] = []
    
    var sixtyMinutesPrices: [Double] = []
    var twentyFourHoursPrices : [Double] = []
    var thirtyDaysPrices : [Double] = []
    var oneYearPrices: [Double] = []
    
    //is the ticker page loaded in, true if the ticker page is loaded, false if favorites page is loaded
    var tickerPageLoaded: Bool = true
    
    
    var favoritePlaces = 0
    
    //favorites data arrays
    var favoriteNames: [String] = []
    var favoriteTickers: [String] = []
    var favoriteIdentifiers: [String] = ["bitcoin"]
    var favoritePrices:[Double] = []
    var favoriteChange1hr:[Double] = []
    var favoriteChange24hr:[Double] = []
    var favoriteChange7d: [Double] = []
    var favoriteTotalSupply: [Double] = []
    var favoriteMarketCap: [Double] = []
    var favoriteVolume: [Double] = []
    
    //runs at startup, makes it so that the favoritesarray is either created in userdefaults if there isnt one and then loaded to the local favoritesarray, or the favoritesarray from nsuserdefaults is loaded onto the local favoritesarray
    func favoriteSetup(){
        if NSUserDefaults.standardUserDefaults().arrayForKey("favoriteIdentifiers") == nil || (NSUserDefaults.standardUserDefaults().arrayForKey("favoriteIdentifiers") as? [String])! == []{
            print("No Favorite array, adding default one")
            
            
            NSUserDefaults.standardUserDefaults().setObject(["bitcoin"], forKey: "favoriteIdentifiers")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        favoriteIdentifiers = (NSUserDefaults.standardUserDefaults().arrayForKey("favoriteIdentifiers") as? [String])!
        
    }
    
    func initFavoriteArrays(favoritePlaces: Int){
        
        self.favoritePlaces = favoritePlaces
        
        //create new temp arrays to copy to the main ones later //leave em blank then append to them
        var newFavoriteNames: [String] = []
        var newFavoriteTickers: [String] = []
        //var newFavoriteIdentifiers: [String] = []
        var newFavoritePrices: [Double] = []
        var newFavoriteChange1hr: [Double] = []
        var newFavoriteChange24hr: [Double] = []
        var newFavoriteChange7d: [Double] = []
        var newFavoriteTotalSupply: [Double] = []
        var newFavoriteVolume: [Double] = []
        var newFavoriteMarketCap: [Double] = []
        
        
        //insert blank space initializers
        for _ in 1...favoritePlaces {
            newFavoriteNames.append("")
            newFavoriteTickers.append("")
            //newFavoriteIdentifiers.append("")
            newFavoritePrices.append(0)
            newFavoriteChange1hr.append(0)
            newFavoriteChange24hr.append(0)
            newFavoriteChange7d.append(0)
            newFavoriteTotalSupply.append(0)
            newFavoriteVolume.append(0)
            newFavoriteMarketCap.append(0)
        }
        
        //copy the new arrays to the main ones
        favoriteNames = newFavoriteNames
        favoriteTickers = newFavoriteTickers
        //favoriteIdentifiers = newFavoriteIdentifiers
        favoritePrices = newFavoritePrices
        favoriteChange1hr = newFavoriteChange1hr
        favoriteChange24hr = newFavoriteChange24hr
        favoriteChange7d = newFavoriteChange7d
        favoriteVolume = newFavoriteVolume
        favoriteMarketCap = newFavoriteMarketCap
        favoriteTotalSupply = newFavoriteTotalSupply
        
        refreshFavoriteData()
        
        NSUserDefaults.standardUserDefaults().setObject(favoriteIdentifiers, forKey: "favoriteIdentifiers")
        
    }
    
    func initArrays(totalPlaces: Int) {
        
        self.totalPlaces = totalPlaces
        
        //create new temp arrays to copy to the main ones later //also insert USD info
        var newCoinNames: [String] = ["US Dollar"]
        var newCoinTickers: [String] = ["USD"]
        var newCoinIdentifiers: [String] = ["dollar"]
        var newCoinPrices: [Double] = [1]
        var newCoinChange1hr: [Double] = [0]
        var newCoinChange24hr: [Double] = [0]
        var newCoinChange7d: [Double] = [0]
        var newCoinTotalSupply: [Double] = [0]
        var newCoinVolume: [Double] = [0]
        var newCoinMarketCap: [Double] = [0]

        
        //insert blank space initializers
        for _ in 1...totalPlaces {
            newCoinNames.append("")
            newCoinTickers.append("")
            newCoinIdentifiers.append("")
            newCoinPrices.append(0)
            newCoinChange1hr.append(0)
            newCoinChange24hr.append(0)
            newCoinChange7d.append(0)
            newCoinTotalSupply.append(0)
            newCoinVolume.append(0)
            newCoinMarketCap.append(0)
        }
        
        //copy the new arrays to the main ones
        coinNames = newCoinNames
        coinTickers = newCoinTickers
        coinIdentifiers = newCoinIdentifiers
        coinPrices = newCoinPrices
        coinChange1hr = newCoinChange1hr
        coinChange24hr = newCoinChange24hr
        coinChange7d = newCoinChange7d
        coinVolume = newCoinVolume
        coinMarketCap = newCoinMarketCap
        coinTotalSupply = newCoinTotalSupply

        
        refreshData()
        
    }
    //var coinNames : [String] = Array(count: 10, repeatedValue: 0)
    
    var dateUpdated = NSDate()
    
    let apiURL = "https://api.coinmarketcap.com/v1/ticker/"
    
    func refreshData(){
        
        //date = NSDate()
        let oldPrices = coinPrices
        
        
        if let url = NSURL(string: apiURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                for i in 1...totalPlaces {
                    coinNames[i] = json[i-1]["name"].stringValue
                    coinTickers[i] = json[i-1]["symbol"].stringValue
                    coinIdentifiers[i] = json[i-1]["id"].stringValue
                    coinPrices[i] = json[i-1]["price_usd"].doubleValue
                    coinChange1hr[i] = json[i-1]["percent_change_1h"].doubleValue
                    coinChange24hr[i] = json[i-1]["percent_change_24h"].doubleValue
                    coinChange7d[i] = json[i-1]["percent_change_7d"].doubleValue
                    coinTotalSupply[i] = json[i-1]["total_supply"].doubleValue
                    coinVolume[i] = json[i-1]["24h_volume_usd"].doubleValue
                    coinMarketCap[i] = json[i-1]["market_cap_usd"].doubleValue
                }
                
                //if the oldprices are = to the updated prices, then update the dateUpdated
                if oldPrices != coinPrices{
                    dateUpdated = NSDate()
                    //printCoins()
                    print("Coin Prices Updated--\(dateUpdated)")
                    
                }
            
            }
            
        }
        
    }//close refreshData
    
    
    //favorites update date
    var favoritesUpdateDate = NSDate()
    
    func refreshFavoriteData(){
        
        //print(favoriteIdentifiers)
        
        let oldPrices = favoritePrices
        
        for i in 0..<favoriteIdentifiers.count{
            
            if let url = NSURL(string: "https://api.coinmarketcap.com/v1/ticker/\(favoriteIdentifiers[i])/") {
                
                //print("Favorite URL: \(url)")
                
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    
                    let json = JSON(data: data)
                    
                    favoriteNames[i] = json[0]["name"].stringValue
                    favoriteTickers[i] = json[0]["symbol"].stringValue
                    //favoriteIdentifiers[i] = json[0]["id"].stringValue
                    favoritePrices[i] = json[0]["price_usd"].doubleValue
                    favoriteChange1hr[i] = json[0]["percent_change_1h"].doubleValue
                    favoriteChange24hr[i] = json[0]["percent_change_24h"].doubleValue
                    favoriteChange7d[i] = json[0]["percent_change_7d"].doubleValue
                    favoriteTotalSupply[i] = json[0]["total_supply"].doubleValue
                    favoriteVolume[i] = json[0]["24h_volume_usd"].doubleValue
                    favoriteMarketCap[i] = json[0]["market_cap_usd"].doubleValue
                    
                }
            
            }
            

            
            
        }
        
        //if the oldprices are = to the updated prices, then update the dateUpdated
        if oldPrices != favoritePrices{
            favoritesUpdateDate = NSDate()
            //printCoins()
            print("Favorites Prices Updated--\(favoritesUpdateDate)")
            
        }
        
        //print("favorite Names \(favoriteNames)")
        
    }
    
    func printCoins(){
        print()
        print("Last updated \(dateUpdated)")
        print()
        for i in 0...coinNames.count-1 {
            print("\(coinNames[i]), \(coinTickers[i]): \(coinPrices[i]) 1hr: \(coinChange1hr[i])%, 24hr: \(coinChange24hr[i])%")
        }
    }
    
    func formatPercentage(percentage: Double) -> String {
        
        //string that will be modified
        var percentString: String = "0.0%"
        //the arrows
        let upArrow: String = "▲"
        let downArrow:String = "▼"
        
        
        if percentage > 0 {
            percentString = "\(upArrow)\(abs(percentage))%"
        } else if percentage < 0 {
            percentString = "\(downArrow)\(abs(percentage))%"
        } else {
            percentString = "\(percentage)%"
        }
        
        return percentString
    }
    
    //format numbers into strings with endings
    func formatThousand(number: Double) -> String {
        let thousandString: String = "\(String(format: "%.2f", number/1000))K"
        return thousandString
    }
    func formatMillion(number: Double) -> String {
        let millionString: String = "\(String(format:"%.2f", number/1000000))M"
        return millionString
    }
    func formatBillion(number: Double) -> String {
        let billionString: String = "\(String(format: "%.2f", number/1000000000))B"
        return billionString
    }
    
    //chooses which format K, M, B, or none to put the number in for use on the info display on the bottom of the screen
    func assessNumberStringFormat(number: Double) -> String {
        var numberString: String
        
        if number >= 1000000000 {
            numberString = formatBillion(number)
        } else if number >= 1000000 {
            numberString = formatMillion(number)
        } else if number >= 1000 {
            numberString = formatThousand(number)
        } else {
            numberString = String(format: "%.2f", number)
        }
        
        return numberString
    }

    func fillChartArrays(){
        
        var indexCell: Int = 1
        var localTickers: [String]
        
        if tickerPageLoaded {
            indexCell = selectedCell
            localTickers = coinTickers
        } else {
            indexCell = selectedFavoriteCell
            localTickers = favoriteTickers
        }
        
        //URL API requests based on the ticker of the coin that you wanted to check the data from
        let sixtyMinutesURL : String = "https://www.cryptocompare.com/api/data/histominute/?aggregate=1&e=CCCAGG&fsym=\(localTickers[indexCell])&limit=60&tsym=USD"
        let twentyFourHoursURL : String = "https://www.cryptocompare.com/api/data/histohour/?aggregate=1&e=CCCAGG&fsym=\(localTickers[indexCell])&limit=24&tsym=USD"
        
        let thirtyDaysURL : String = "https://www.cryptocompare.com/api/data/histoday/?aggregate=1&e=CCCAGG&fsym=\(localTickers[indexCell])&limit=30&tsym=USD"
        let oneYearURL: String = "https://www.cryptocompare.com/api/data/histoday/?aggregate=1&e=CCCAGG&fsym=\(localTickers[indexCell])&limit=365&tsym=USD"
        
        /*
        //print the URLS into console for checking purposes
        print("sixty mins URL: \(sixtyMinutesURL)")
        print("twenty four hours URL: \(twentyFourHoursURL)")
        print("thirty days URL: \(thirtyDaysURL)")
        print("one year URL: \(oneYearURL)")
        */
        
        //set them to blank, then refill
        //arrays for chart
        sixtyMinutesPrices  = []
        twentyFourHoursPrices  = []
        thirtyDaysPrices = []
        oneYearPrices = []
        
        sixtyMinutesDates = []
        twentyFourHoursDates = []
        thirtyDaysDates = []
        oneYearDates = []
        
        //json["Data"][i]["time"].doubleValue
        
        //fill all the arrays with data
        if let url = NSURL(string: sixtyMinutesURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                for i in 0..<json["Data"].count {
                    sixtyMinutesDates.append(NSDate(timeIntervalSince1970: json["Data"][i]["time"].doubleValue))
                    sixtyMinutesPrices.append(json["Data"][i]["close"].doubleValue)
                    
                }
                
                
            }
            
        }
        
        if let url = NSURL(string: twentyFourHoursURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                for i in 0..<json["Data"].count {
                    twentyFourHoursDates.append(NSDate(timeIntervalSince1970: json["Data"][i]["time"].doubleValue))
                    twentyFourHoursPrices.append(json["Data"][i]["close"].doubleValue)
                }
                
            }
            
        }
        
        if let url = NSURL(string: thirtyDaysURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                for i in 0..<json["Data"].count {
                    thirtyDaysDates.append(NSDate(timeIntervalSince1970: json["Data"][i]["time"].doubleValue))
                    thirtyDaysPrices.append(json["Data"][i]["close"].doubleValue)
                }
                
            }
            
        }
        
        if let url = NSURL(string: oneYearURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                for i in 0..<json["Data"].count {
                    oneYearDates.append(NSDate(timeIntervalSince1970: json["Data"][i]["time"].doubleValue))
                    oneYearPrices.append(json["Data"][i]["close"].doubleValue)
                }
            }
            
        }
        
    }//end fillChartArrays func
    
    //print all price history for debugging/developer purposes
    func printChartDicts() {
        
        print()
        print("Last Hour:")
        print()
        if sixtyMinutesDates.count > 0 {
            for i in 0...sixtyMinutesDates.count-1 {
                print("\(sixtyMinutesDates[i]): \(sixtyMinutesPrices[i])")
            }
        } else {
            print("no data available")
        }
        print()
        print("Last 24 Hours:")
        print()
        if twentyFourHoursDates.count > 0 {
            for i in 0...twentyFourHoursDates.count-1 {
                print("\(twentyFourHoursDates[i]): \(twentyFourHoursPrices[i])")
            }
        } else {
            print("no data available")
        }
        print()
        print("Last Thirty Days:")
        print()
        if thirtyDaysDates.count > 0 {
            for i in 0...thirtyDaysDates.count-1 {
                print("\(thirtyDaysDates[i]): \(thirtyDaysPrices[i])")
            }
        } else {
            print("no data available")
        }
        print()
        print("Year to date:")
        print()
        if oneYearDates.count > 0 {
            for i in 0...oneYearDates.count-1 {
                print("\(oneYearDates[i]): \(oneYearPrices[i])")
            }
        } else {
            print("no data available")
        }
    }
    
    func getBTCBalance(address: String) -> Double {
        var balance : Double = 0.0
        
        let genURL = "https://blockchain.info/q/addressbalance/\(address)"
        
        //print(genURL)
        
        if address != "" {
            if let url = NSURL(string: genURL){
                if let data = try? NSData(contentsOfURL: url, options: []){
                    let json = JSON(data: data)
                
                    balance = json.doubleValue/100000000
                }
            
            }
            
            print("BTC Address \(address): \(balance)BTC")
            
        } else {
             print("No BTC Adress entered, not fetching JSON")
        }
        
        

        return balance
    }
    
    func getETHBalance(address: String) -> Double {
        var balance: Double = 0.0
    
        let genURL = "https://etherchain.org/api/account/\(address)"
        
        //print(genURL)
        
        if address != "" {
            if let url = NSURL(string: genURL){
                if let data = try? NSData(contentsOfURL: url, options: []){
                    let json = JSON(data: data)
                    
                    balance = json["data"][0]["balance"].doubleValue / 1000000000000000000
                    
                }
                
            }
            
            print("ETH Address \(address): \(balance)ETH")
            
        } else {
            print("No ETH Adress entered, not fetching JSON")
        }
        
        return balance
    }
    
    func getDOGEBalance(address: String) -> Double{
        var balance: Double = 0.0
        
        let genURL = "https://dogechain.info/api/v1/address/balance/\(address)"
        
        //print(genURL)
        
        if address != "" {
            if let url = NSURL(string: genURL){
                if let data = try? NSData(contentsOfURL: url, options: []){
                    let json = JSON(data: data)
                    
                    balance = json["balance"].doubleValue
                    
                }
                
            }
            
            print("DOGE Address \(address): \(balance)DOGE")
            
        } else {
            print("No DOGE Adress entered, not fetching JSON")
        }
        
        return balance
    }
    
    //get price for any coin from coinmarketcap api from the id within the api call
        //id in the coinmarketcap API is usually the coin's name in all lowercase, check api if its not
    func getCurrentPriceFromID(id: String) -> Double {
        var coinPrice: Double = 0.0
        
        let priceURL = "https://api.coinmarketcap.com/v1/ticker/\(id)/"
        
        if let url = NSURL(string: priceURL){
            if let data = try? NSData(contentsOfURL: url, options: []){
                let json = JSON(data: data)
                
                coinPrice = json[0]["price_usd"].doubleValue
            }
        }
        
        return coinPrice
    }
    
    //format a money amount into a string with a selected amount of decimal points, include the symbol argument if i want to use the BTC symbol or perhaps pounds/euros in future
    func formatMoneyString(symbol: Character, amount: Double, places: Int) -> String {
        
        
        //formatting string from passed places
        let decimalPointFormatString = "%.\(places)f"
        
        let moneyString: String = "\(symbol)\(String(format: decimalPointFormatString, amount))"
        
        return moneyString
    
    }
    
    func doesEqualStringInArray(item: String, array: [String]) -> Bool {
        var doesEqual: Bool = false
        
        var i: Int = 0
        
        repeat {
        
            if item ==  array[i] {
        
                doesEqual = true
        
            }
        
            i += 1
            
        } while i < array.count && doesEqual == false
        
        return doesEqual
    
    }
    
    func stringTimeFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func openURL(url: String) {
        
        let url = NSURL(string: url)!
        UIApplication.sharedApplication().openURL(url)
        
    }
    
}
