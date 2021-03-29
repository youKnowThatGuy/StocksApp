//
//  NewsData.swift
//  StocksApp
//
//  Created by Клим on 29.03.2021.
//

import Foundation

struct NewsData: Decodable{
    var headline: String
    var image: String
    var source: String
    var summary: String
    var url: String
}
