//
//  NewsViewCell.swift
//  StocksApp
//
//  Created by Клим on 29.03.2021.
//

import UIKit

class NewsViewCell: UITableViewCell {
    @IBOutlet weak var headLabel: UILabel!
    
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    static let identifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
