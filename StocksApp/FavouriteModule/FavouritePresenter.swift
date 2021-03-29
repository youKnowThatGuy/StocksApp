//
//  FavouritePresenter.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import UIKit

protocol FavouritePresenterProtocol{
    init(view: FavouriteViewProtocol)
    
    func loadData()
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func prepareCell(cell: StocksViewCell, index: Int)-> StocksViewCell
    func getSegueData(index: Int) -> String
    var tickerArray: [String] {get}
}


class FavouritePresenter: FavouritePresenterProtocol{
    weak var view: FavouriteViewProtocol?
    //var stockArray =  [StockDayInfo]()
    var tickerArray = [String]()
    var nameArray = [String]()
    var rawData = [String]()
    var viewLoaded = false
    
    required init(view: FavouriteViewProtocol) {
        self.view = view
        loadData()
    }
    
    @objc func reloadData(){
        loadData()
    }
    
    func loadData(){
        tickerArray.removeAll()
        nameArray.removeAll()
        CacheManager.shared.getFavourites { [self] (string) in
            let dataArray = string.components(separatedBy: ", ")
            self.rawData = dataArray
            for data in dataArray{
                if (data != "") {
                let miniArray = data.components(separatedBy: ";")
                tickerArray.append(miniArray[0])
                nameArray.append(miniArray[1])
                }
            }
            if viewLoaded{
            self.view?.updateUI()
            }
            viewLoaded = true
        }
        
        
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showDetailFromFavourites":
            guard let vc = segue.destination as? DetailScrollViewController,
                  let data = sender as? String
            else {fatalError("Invalid data passed")}
            vc.data = data
            WSManager.shared.unSubscribeMainPageStocks()
        default:
            break
        }
    }
    
    
    func getSegueData(index: Int) -> String {
        let data = tickerArray[index] + ";" + nameArray[index]
        return data
    }
    
    func prepareCell(cell: StocksViewCell, index: Int) -> StocksViewCell {
        let currStock = tickerArray[index]
        NetworkService.shared.fetchSingleStockData(stock: currStock) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(stockData):
                //cell.prepareReuse()
                let price = Double(round(stockData.c * 100)/100)
                cell.priceLabel.text = "\(price) $"
                cell.tickerLabel.text = currStock
                cell.companyLabel.text = self.nameArray[index]
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
    
}

extension FavouritePresenter: FavouriteProtocol{
    func updateFavourites(ticker: String, name: String) -> Bool {
        let index = tickerArray.firstIndex(of: ticker)!
        rawData.remove(at: index)
        CacheManager.shared.cacheFavourites(rawData.joined(separator: ", "))
        _ = Timer.scheduledTimer(
          timeInterval: 2.5, target: self, selector: #selector(reloadData),
          userInfo: nil, repeats: false)
        view?.updateUI()
        return false
    }
    
    func contains(ticker: String, name: String) -> Bool {
        return true
        }
    }
