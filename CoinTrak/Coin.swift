//
//  Coin.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 7/25/17.
//  Copyright © 2017 John Chiaramonte. All rights reserved.
//

import Foundation

class Coin {
    
    var coinName: String
    var coinTicker: String
    var coinIdentifier: String
    var coinPrice: Double
    var coinChange1hr: Double
    var coinChange24hr: Double
    var coinChange7d: Double
    var coinTotalSupply: Double
    var coinVolume: Double
    var coinMarketCap: Double
    var isAd: Bool = false
    var coinRank: Int = 0
    
    init(name: String, ticker: String, identifier: String, price: Double, change1hr: Double, change24hr: Double, change7d: Double, totalSupply: Double, volume: Double, marketCap: Double){
        coinName = name
        coinTicker = ticker
        coinIdentifier = identifier
        coinPrice = price
        coinChange1hr = change1hr
        coinChange24hr = change24hr
        coinChange7d = change7d
        coinTotalSupply = totalSupply
        coinVolume = volume
        coinMarketCap = marketCap
 
    }
    
}
