//
//  StockProfile.swift
//  StocksApp
//
//  Created by Клим on 29.03.2021.
//

import Foundation

struct StockProfile: Decodable {
    var country: String
    var currency: String
    var exchange: String
    var ipo: String
    var name: String
    var weburl: String
    var logo: String
    var finnhubIndustry: String
}
