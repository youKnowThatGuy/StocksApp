//
//  CandleResponse.swift
//  StocksApp
//
//  Created by Клим on 28.03.2021.
//

import Foundation

struct CandleResponse: Decodable{
    var c: [Double]
    var h: [Double]
    var l: [Double]
    var o: [Double]
    var t: [Int]
}
