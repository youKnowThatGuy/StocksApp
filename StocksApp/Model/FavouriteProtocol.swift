//
//  FavouriteProtocol.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import Foundation

protocol FavouriteProtocol{
    func updateFavourites(ticker: String, name: String) -> Bool
    func contains(ticker: String, name: String) -> Bool
}
