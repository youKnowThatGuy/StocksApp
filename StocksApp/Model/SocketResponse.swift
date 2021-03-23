//
//  SocketResponse.swift
//  StocksApp
//
//  Created by Клим on 11.03.2021.
//

import Foundation

struct SocketResponse<Object:Decodable>: Decodable {
    var data: [Object]
}

struct StockInfo: Decodable {
    var p: Double
    var s: String
    var t: Int
}
