//
//  NewsPresenter.swift
//  StocksApp
//
//  Created by Клим on 29.03.2021.
//

import Foundation
import UIKit

protocol NewsPresenterProtocol{
    init(view: NewsViewProtocol, ticker: String, company: String)
    func getData()
    func prepareCell(cell: NewsViewCell, index: Int)
    func newsCount()-> Int
    func getNewsUrl(index: Int) -> String
}

class NewsPresenter: NewsPresenterProtocol{
    weak var view: NewsViewProtocol?
    var stockTicker = ""
    var company = ""
    var newsArray = [NewsData]()
    var urlArray = [String]()
    var currDate = ""
    var weekDate = ""
    
    required init(view: NewsViewProtocol, ticker: String, company: String) {
        self.view = view
        self.stockTicker = ticker
        self.company = company
        getCurrentDates()
        getData()
    }
    
    func getData() {
        NetworkService.shared.fetchNewsData(stock: stockTicker, startDate: weekDate, endDate: currDate) { (result) in
            switch result{
            case let .failure(error):
                print(error)
            
            case let .success(newsInfo):
                self.newsArray = newsInfo
                for news in newsInfo{
                    self.urlArray.append(news.url)
                }
            }
        }
    }
    
    func prepareCell(cell: NewsViewCell, index: Int) {
        let news = newsArray[index]
        cell.headLabel.text = news.headline
        cell.sourceLabel.text = "Source: \(news.source)"
        cell.summaryLabel.text = news.summary
    }
    
    func newsCount() -> Int {
        newsArray.count
    }
    
    
    func getNewsUrl(index: Int) -> String {
        return newsArray[index].url
    }
    
    func getCurrentDates(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        currDate = result
        let dateString = formatter.date(from: result)
        var stamp = Int(dateString!.timeIntervalSince1970)
        stamp = stamp - 604800
        weekDate = formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(stamp)) as Date)
    }
    
    func resiezeImg(image: UIImage) -> UIImage{
        let targetSize = CGSize(width: 240, height: 138.5)
        let scaledImage = image.scalePreservingAspectRatio(
            targetSize: targetSize)
        return scaledImage
    }
}

extension UIImage{
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
            // Determine the scale factor that preserves aspect ratio
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            let scaleFactor = min(widthRatio, heightRatio)
            
            // Compute the new image size that preserves aspect ratio
            let scaledImageSize = CGSize(
                width: size.width * scaleFactor,
                height: size.height * scaleFactor
            )

            // Draw and return the resized UIImage
            let renderer = UIGraphicsImageRenderer(
                size: scaledImageSize
            )

            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(
                    origin: .zero,
                    size: scaledImageSize
                ))
            }
            
            return scaledImage
        }
}

