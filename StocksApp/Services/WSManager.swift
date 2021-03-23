//
//  WSManager.swift
//  StocksApp
//
//  Created by Клим on 11.03.2021.
//

import Foundation

class WSManager {
    public static let shared = WSManager()
    private init(){}
    
    private let apiKey = "c14emtn48v6t40fvebdg"
    
    private var dataArray = [StockInfo]()
    private let mainStocks = ["YNDX","AAPL", "AMZN", "GOOGL", "TSLA", "SPCE","MRNA"]
    
    private let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://ws.finnhub.io/?token=c14emtn48v6t40fvebdg")!)
    
   //функция вызова подключения
    public func connectToWebSocket() {
        webSocketTask.resume()
        self.receiveData() { _ in }
    }
    
//функция подписки на что либо
     func subscribeMainPageStocks() {
        for stock in mainStocks
        {
        let message = URLSessionWebSocketTask.Message.string("{\"type\":\"subscribe\",\"symbol\":\"\(stock)\"}")
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
        }
    }

//функция отписки от чего либо
     func unSubscribeMainPageStocks() {
        for stock in mainStocks
        {
           let message = URLSessionWebSocketTask.Message.string("{\"type\":\"subscribe\",\"symbol\":\"\(stock)\"}")
           webSocketTask.send(message) { error in
               if let error = error {
                   print("WebSocket couldn’t send message because: \(error)")
               }
           }
        }
       }
    
//функция получения данных, с эскейпингом чтобы получить данные наружу
    func receiveData(completion: @escaping ([StockInfo]?) -> Void) {
      webSocketTask.receive { result in
        switch result {
            case .failure(let error):
              print("Error in receiving message: \(error)")
            case .success(let message):
              switch message {
                case .data(let data):
                    do {
                        let socketResponse = try JSONDecoder().decode(SocketResponse<StockInfo>.self, from: data)
                        self.dataArray = socketResponse.data
                    }
                    catch {
                        DispatchQueue.main.async {
                            completion([])
                        }
                    }
                    print("Received data: \(data)")
              case .string(let text):
                let data: Data! = text.data(using: .utf8)
                do {
                    let socketResponse = try JSONDecoder().decode(SocketResponse<StockInfo>.self, from: data)
                    self.dataArray = socketResponse.data
                }
                catch {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
              @unknown default:
                debugPrint("Unknown message")
              }
              self.receiveData() {_ in } // рекурсия
        }
      
        completion(self.dataArray)
      }
    }
}
