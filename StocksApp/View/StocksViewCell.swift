//
//  StocksViewCell.swift
//  StocksApp
//
//  Created by Клим on 16.03.2021.
//

import UIKit

class StocksViewCell: UITableViewCell {
    
    static let identifier = "StocksCell"

    @IBOutlet weak var tickerLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var differenceLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    var presenter: FavouriteProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func grayView(){
        tickerLabel.textColor = UIColor.white
        priceLabel.textColor = UIColor.white
        companyLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.gray
    }
    
    func checkTicker(){
        let contains = presenter?.contains(ticker: tickerLabel.text!,name: companyLabel.text!)
        if contains! == true  {
            favouriteButton.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
        }
        else{
            favouriteButton.setImage(UIImage.init(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func makeFavButton(_ sender: UIButton) {
        let flag = presenter?.updateFavourites(
            ticker: tickerLabel.text!,
            name: companyLabel.text!)
        
        if flag == false{
        sender.setImage(UIImage.init(systemName: "star"), for: .normal)
        }
        else{
            sender.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
