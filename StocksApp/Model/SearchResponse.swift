//
//  SearchResponse.swift
//  StocksApp
//
//  Created by Клим on 23.03.2021.
//

import Foundation

struct SearchResponse<Object:Decodable>: Decodable {
    var result: [Object]
}

struct FoundStock: Decodable{
    var description: String
    var symbol: String
}
