//
//  SessionError.swift
//  StocksApp
//
//  Created by Клим on 22.03.2021.
//

import Foundation

enum SessionError: Error{
    case invalidUrl, decodingError(Error), serverError(_ statusCode: Int), other(Error)
    
    var localizedDescription: String{
        
        switch self{
        case .invalidUrl:
            return "Invalid URL address"
            
        case let .decodingError(error):
            return error.localizedDescription
            
        case let .serverError(statusCode):
            return "Couldnt connect to server \(statusCode)"
            
        case let .other(error):
            return error.localizedDescription
        }
        
    }
    
}
