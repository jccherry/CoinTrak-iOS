//
//  ConvertCoinCell.swift
//  CoinTrak
//
//  Created by John Chiaramonte on 12/10/17.
//  Copyright © 2017 John Chiaramonte. All rights reserved.
//

import UIKit

class ConvertCoinCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
