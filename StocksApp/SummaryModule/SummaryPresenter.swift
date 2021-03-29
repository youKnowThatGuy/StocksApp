//
//  SummaryPresenter.swift
//  StocksApp
//
//  Created by Клим on 28.03.2021.
//

import Foundation
import UIKit

protocol SummaryPresenterProtocol{
    init(view: SummaryViewProtocol, ticker: String, company: String)
    func getData()
    var profile: StockProfile! {get}
    var company: String {get}
}

class SummaryPresenter: SummaryPresenterProtocol{
    weak var view: SummaryViewProtocol?
    var stockTicker = ""
    var company = ""
    var profile: StockProfile!
        
    required init(view: SummaryViewProtocol, ticker: String, company: String) {
        self.view = view
        self.stockTicker = ticker
        self.company = company
    }
    
    func getData() {
        NetworkService.shared.fetchProfileStockData(stock: stockTicker) { (result) in
            switch result{
            case let .failure(error):
                print(error)
                self.profile = StockProfile(country: "no data", currency: "no data", exchange: "no data", ipo: "no data", name: "no data", weburl: "no data", logo: "no data", finnhubIndustry: "no data")
            
            case let .success(data):
                self.profile = data
                self.view?.updateUI()
            }
        }
    }
    
    
    
    
}
