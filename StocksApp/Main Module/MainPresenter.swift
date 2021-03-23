//
//  MainPresenter.swift
//  StocksApp
//
//  Created by Клим on 11.03.2021.
//

import UIKit

protocol MainPresenterProtocol{
    init(view: MainViewProtocol)
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func connectToSocket()
    func getData()
    func stockCount()-> Int
    func prepareCell(cell: StocksViewCell, index: Int)-> StocksViewCell
    func saveRecentSearch(query: String)
    func loadRecentSearches()
    func loadStocks(query: String)
    func switchSearch()
    func loadFavourites()
}

class MainPresenter: MainPresenterProtocol{
    weak var view: MainViewProtocol?
    
     var stockArray = [StockInfo(p: 0, s: "BA", t: 0), StockInfo(p: 0, s: "AAPL", t: 0), StockInfo(p: 0, s: "AMZN", t: 0), StockInfo(p: 0, s: "GOOGL", t: 0), StockInfo(p: 0, s: "TSLA", t: 0), StockInfo(p: 0, s: "SPCE", t: 0), StockInfo(p: 0, s: "MRNA", t: 0)]
    var nameArray = ["Boeing", "Apple Inc.", "Amazon.com", "Alphabet Class A", "Tesla Motors", "Virgin Galactic", "Moderna"]
    var stockDaily = [StockDayInfo]()
    
    var searchedData = [FoundStock]()
    var searchOn = false
    
    var favourites = [String]()
    
    required init(view: MainViewProtocol) {
        self.view = view
        getDailyData()
        loadFavourites()
        
    }
    
    func loadFavourites(){
        CacheManager.shared.getFavourites { (string) in
            self.favourites = string.components(separatedBy: ", ")
            //self.favourites.removeAll()
        }
    }
    
    func getDailyData(){
        NetworkService.shared.fetchMultiStockData(stockList: ["BA", "AAPL", "AMZN", "GOOGL", "TSLA", "SPCE", "MRNA" ]) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(multiInfo):
                self.stockDaily = multiInfo
            }
        }
    }
    
    func connectToSocket(){
        WSManager.shared.connectToWebSocket()
        WSManager.shared.subscribeMainPageStocks()
    }
    
    func getData() {
            WSManager.shared.receiveData() { [weak self] (data) in
                guard let self = self else { return }
                guard let data = data else { return }
                var dataBlank = self.stockArray
                
                for j in 0..<dataBlank.count{
                    for i in 0..<data.count{
                        if dataBlank[j].s == data[i].s{
                        dataBlank[j] = data[i]
                    }
                }
                }
                self.stockArray = dataBlank
                self.view?.updateUI()
            }
        }
    
    func stockCount() -> Int {
        if searchOn {
            return 1
        }
        return stockArray.count
    }
    
    func switchSearch(){
        searchedData.removeAll()
        searchOn = false
        connectToSocket()
    }
    
    func prepareCell(cell: StocksViewCell, index: Int) -> StocksViewCell {
        if searchOn {
            let currStock = searchedData[index]
            NetworkService.shared.fetchSingleStockData(stock: currStock.symbol) { (result) in
                switch result{
                case let .failure(error):
                    print(error)
                
                case let .success(stockData):
                    //cell.prepareReuse()
                    let price = Double(round(stockData.c * 100)/100)
                    cell.priceLabel.text = "\(price) $"
                    cell.tickerLabel.text = currStock.symbol
                    cell.companyLabel.text = currStock.description
                    var difference = price - stockData.o
                    difference = Double(round(difference * 100)/100)
                    cell.differenceLabel.text = "\(difference) $"
                    if difference < 0{
                        cell.differenceLabel.textColor = UIColor.systemRed
                    }
                    else{
                        cell.differenceLabel.textColor = UIColor.systemGreen
                        cell.differenceLabel.text = "+ \(difference) $"
                    }
                }
            }
            cell.presenter = (self as FavouriteProtocol)
            return cell
        }
        
        else{
        var difference = 0.0
        let currStock = stockArray[index]
        let price = Double(round(currStock.p * 100)/100)
        cell.priceLabel.text = "\(price) $"
        cell.tickerLabel.text = "\(currStock.s)"
        cell.companyLabel.text = nameArray[index]
        if stockDaily.count < stockArray.count{
            difference = 0
        }
        else{
            let openPrice = stockDaily[index].o
            difference = price - openPrice
            difference = Double(round(difference * 100)/100)
        }
        cell.differenceLabel.text = "\(difference) $"
        if difference < 0{
            cell.differenceLabel.textColor = UIColor.systemRed
        }
        else{
            cell.differenceLabel.textColor = UIColor.systemGreen
            cell.differenceLabel.text = "+ \(difference) $"
        }
        cell.presenter = (self as FavouriteProtocol)
        
        return cell
        }
    }
    
   
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Good!")
    }
    
    func loadRecentSearches() {
        CacheManager.shared.getSearches { (searches) in
            self.view!.resultsTableViewController.suggestedSearches = searches.components(separatedBy: ", ")
        }
    }
    
    func saveRecentSearch(query: String){
       CacheManager.shared.cacheSearches(query)
   }
    
    func loadStocks(query: String) {
        searchedData.removeAll()
        NetworkService.shared.fetchSearchStockData(query: query) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(searchInfo):
                self.searchedData = searchInfo
                self.searchOn = true
                WSManager.shared.unSubscribeMainPageStocks()
                if (searchInfo.count != 0) {
                self.view!.clearUI()
                }
            }
        }
    }
    
}

extension MainPresenter: FavouriteProtocol{
    func contains(ticker: String, name: String) -> Bool {
        let data = ticker + ";" + name
        if favourites.contains(data){
            return true
        }
        else{
        return false
        }
    }
    
    func updateFavourites(ticker: String, name: String) -> Bool {
        let data = ticker + ";" + name
        if favourites.contains(data){
            let index = favourites.firstIndex(of: data)!
            favourites.remove(at: index)
            CacheManager.shared.cacheFavourites(favourites.joined(separator: ", "))
            return false
        }
        else{
            favourites.append(data)
            CacheManager.shared.cacheFavourites(favourites.joined(separator: ", "))
            return true
        }
        
    }
}
