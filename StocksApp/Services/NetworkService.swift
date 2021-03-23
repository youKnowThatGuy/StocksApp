//
//  NetworkService.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import Foundation

class NetworkService{
    private init() {}
    static let shared = NetworkService()
    
    private let apiKey = "c14emtn48v6t40fvebdg"
    
    
    func fetchMultiStockData(stockList: [String],completion: @escaping (Result<[StockDayInfo], SessionError>) -> Void){
        var count = 0
        var stocksData = [StockDayInfo]()
        stocksData = Array(repeating: StockDayInfo(c: 0, o: 0), count: stockList.count)
        
        for i in 0..<stockList.count{
            fetchSingleStockData(stock: stockList[i]) { (result) in
                switch result{
                case let .failure(error):
                    print(error)
                
                case let .success(stockInfo):
                    stocksData.remove(at: i)
                    stocksData.insert(stockInfo, at: i)
                    count += 1
                    if count == stockList.count{
                        DispatchQueue.main.async {
                            completion(.success(stocksData))
                        }
                    }
                    }
                }
        }
    }
    
    func fetchSingleStockData(stock: String, completion: @escaping (Result<StockDayInfo, SessionError>) -> Void){
        
        guard let url = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(stock)&token=c14emtn48v6t40fvebdg") else {  DispatchQueue.main.async {
            completion(.failure(.invalidUrl))
        }
        return}
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            let response = response as! HTTPURLResponse
            
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            do {
                let networkResponse = try JSONDecoder().decode(StockDayInfo.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(networkResponse))
                }
            }
            catch let decodingError{
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
                
            }
            
        }.resume()
    }
    
    func fetchSearchStockData(query: String, completion: @escaping (Result<[FoundStock], SessionError>) -> Void){
        let url = URL(string: "https://finnhub.io/api/v1/search?q=\(query)&token=c14emtn48v6t40fvebdg")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            let response = response as! HTTPURLResponse
            
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            do {
                let networkResponse = try JSONDecoder().decode(SearchResponse<FoundStock>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(networkResponse.result))
                }
            }
            catch let decodingError{
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
                
            }
            
        }.resume()
    }
    
    
    
}
