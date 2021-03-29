//
//  ChartPresenter.swift
//  StocksApp
//
//  Created by Клим on 27.03.2021.
//

import Foundation
import Charts

protocol ChartPresenterProtocol{
    init(view: ChartViewProtocol, ticker: String, company: String)
    func getData()
    func getChartData() -> CandleChartData?
    func connectToSingleSocket()
    func disconnectToSingleSocket()
    var currPrice: Double {get}
    var change: Double {get}
    var stockTicker: String {get}
    var company: String {get}
    var choice: Int {get set}
}


class ChartPresenter: ChartPresenterProtocol{
    weak var view: ChartViewProtocol?
    var stockTicker = ""
    var company = ""
    var change = 0.0
    var currPrice = 0.0
    var dailyPrice = 0.0
    var candleData: [CandleResponse]!
    var currDate = 0
    var choice = 5
    
    required init(view: ChartViewProtocol, ticker: String, company: String) {
        self.view = view
        self.stockTicker = ticker
        self.company = company
        getCurrDate()
        getDailyData()
        getCandleData()
        connectToSingleSocket()
    }
    
    func getCandleData(){
        NetworkService.shared.fetchMultiCandleData(currDate: currDate, stock: stockTicker ) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(data):
                self.candleData = data
            }
        }
    }
    
    func getCurrDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let result = formatter.string(from: date)
        let dateString = formatter.date(from: result)
        let stamp = dateString!.timeIntervalSince1970
        currDate = Int(stamp)
    }
    
    func connectToSingleSocket(){
        WSManager.shared.subscribeToStock(ticker: stockTicker)
    }
    
    func disconnectToSingleSocket(){
        WSManager.shared.unSubscribeToStock(ticker: stockTicker)
    }
    
    func getData() {
        WSManager.shared.receiveData() { [weak self] (data) in
            guard let self = self else { return }
            guard let data = data else { return }
            self.currPrice = data[0].p
            self.change = Double(round((self.currPrice - self.dailyPrice) * 100)/100)
            self.view?.updateUI()
        }
    }
    
    func getDailyData(){
        NetworkService.shared.fetchMultiStockData(stockList: ["\(stockTicker)"]) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(multiInfo):
                self.currPrice = multiInfo[0].c
                self.dailyPrice = multiInfo[0].o
                self.change = Double(round((self.currPrice - self.dailyPrice) * 100)/100)
                self.view?.updateUI()
            }
        }
    }
    
    func getChartData() -> CandleChartData? {
        if candleData == nil {
            return nil
        }
        let periodData = candleData[choice]
        
        var dataEntries = [CandleChartDataEntry]()
        if candleData == nil{
            return nil
        }
        for i in 0..<periodData.t.count{
            let open = Double(round(periodData.o[i] * 100)/100)
            let close = Double(round(periodData.c[i] * 100)/100)
            let high = Double(round(periodData.h[i] * 100)/100)
            let low = Double(round(periodData.l[i] * 100)/100)
            let timeStamp = periodData.t[i]
            
            let dataEntry = CandleChartDataEntry(x: Double(timeStamp), shadowH: high, shadowL: low, open: open, close: close)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = CandleChartDataSet(entries: dataEntries, label: "")
        /*
        chartDataSet.axisDependency = .left
        chartDataSet.drawIconsEnabled = false
        chartDataSet.shadowColor = .darkGray
        chartDataSet.shadowWidth = 0.7
        chartDataSet.decreasingColor = .red
        chartDataSet.decreasingFilled = true   // fill up the decreasing field color
        chartDataSet.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        chartDataSet.increasingFilled = true  // fill up the increasing field color
        chartDataSet.neutralColor = .blue
        chartDataSet.barSpace = 1.0
        chartDataSet.drawValuesEnabled = false
 */

        return CandleChartData(dataSet: chartDataSet)
    }
    
    func stringFromTimestamp(_ timeInterval : Double)->String {
            let dateFormatter = DateFormatter()
            //self.setDateFormat(dateFormatter,dateFormat: strDateFormat)
            let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
            return dateFormatter.string(from: date)
        }
    
    
}
