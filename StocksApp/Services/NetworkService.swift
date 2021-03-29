//
//  NetworkService.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import Foundation
import UIKit

class NetworkService{
    private init() {}
    static let shared = NetworkService()
    private let apiKey = "c14emtn48v6t40fvebdg"
    
    func fetchMultiStockData(stockList: [String],completion: @escaping (Result<[StockDayInfo], SessionError>) -> Void){
        var stocksData = Array(repeating: StockDayInfo(c: 0, o: 0), count: stockList.count)
        
        let group = DispatchGroup()
        for i in 0..<stockList.count{
            group.enter()
            fetchSingleStockData(stock: stockList[i]) { (result) in
                switch result{
                case let .failure(error):
                    print(error)
                
                case let .success(stockInfo):
                    stocksData.remove(at: i)
                    stocksData.insert(stockInfo, at: i)
                    group.leave()
                    group.notify(queue: .main){
                            completion(.success(stocksData))
                    }
                    }
                }
        }
    }
    
    func fetchSingleStockData(stock: String, completion: @escaping (Result<StockDayInfo, SessionError>) -> Void){
        
        guard let url = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(stock)&token=\(apiKey)") else {  DispatchQueue.main.async {
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
        let url = URL(string: "https://finnhub.io/api/v1/search?q=\(query)&token=\(apiKey)")!
        
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
    
    func fetchMultiCandleData(currDate: Int, stock: String,completion: @escaping (Result<[CandleResponse], SessionError>) -> Void){
        let resolutions = ["15", "60", "D", "W", "W", "M"]
        let startDates = [currDate - 193600, currDate - 604800, currDate - 2419200, currDate - 22032000, currDate - 44064000, 1262353138]
        var stocksData = Array(repeating: CandleResponse(c: [], h: [], l: [], o: [], t: []), count: 6)
        
        let group = DispatchGroup()
        for i in 0..<resolutions.count{
            group.enter()
            fetchCandleStockData(startDate: startDates[i], endDate: currDate, symbol: stock, resolution: resolutions[i]) { (result) in
                switch result{
                case let .failure(error):
                    print(error)
                
                case let .success(candleInfo):
                    stocksData.remove(at: i)
                    stocksData.insert(candleInfo, at: i)
                    group.leave()
                    group.notify(queue: .main){
                            completion(.success(stocksData))
                    }
                    }
                }
        }
    }
    
    private func fetchCandleStockData(startDate: Int, endDate: Int,symbol: String, resolution: String ,completion: @escaping (Result<CandleResponse, SessionError>) -> Void){
        let url = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=\(symbol)&resolution=\(resolution)&from=\(startDate)&to=\(endDate)&token=\(apiKey)")!
        
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
                let networkResponse = try JSONDecoder().decode(CandleResponse.self, from: data)
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
    
    func fetchProfileStockData(stock: String, completion: @escaping (Result<StockProfile, SessionError>) -> Void){
        
        guard let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(stock)&token=\(apiKey)") else {  DispatchQueue.main.async {
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
                let networkResponse = try JSONDecoder().decode(StockProfile.self, from: data)
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
    
    func fetchNewsData(stock: String, startDate: String, endDate: String, completion: @escaping (Result<[NewsData], SessionError>) -> Void){
        
        guard let url = URL(string: "https://finnhub.io/api/v1/company-news?symbol=\(stock)&from=\(startDate)&to=\(endDate)&token=\(apiKey)") else {  DispatchQueue.main.async {
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
                let networkResponse = try JSONDecoder().decode([NewsData].self, from: data)
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
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void){
        guard let url = url else{
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data{
                    completion(UIImage(data: data))
                }
                else{
                    completion(nil)
                }
            }
        }.resume()
    }

}
