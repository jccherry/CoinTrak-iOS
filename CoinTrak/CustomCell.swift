//
//  CustomCell.swift
//  
//
//  Created by John Chiaramonte on 6/24/16.
//
//

import UIKit

class CustomCell: UITableViewCell{
    
    //connect labels from the prototype cell in the storyboard
    @IBOutlet var name: UILabel!
    @IBOutlet var ticker: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var percent1hr: UILabel!
    
    
    @IBOutlet weak var coinImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
