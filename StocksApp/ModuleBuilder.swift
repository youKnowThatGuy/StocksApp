//
//  ModuleBuilder.swift
//  StocksApp
//
//  Created by Клим on 12.03.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(mainView: PageScrollViewController) -> UIViewController
    func createFavouriteModule(mainView: PageScrollViewController) -> UIViewController
    func createChartModule(ticker: String, company: String) -> UIViewController
    func createSummaryModule(ticker: String, company: String) -> UIViewController
    func createNewsModule(ticker: String, company: String) -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol{
    func createMainModule(mainView: PageScrollViewController) -> UIViewController {
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StocksMain") as MainViewController
        
        let navVC = UINavigationController(rootViewController: mainVC)
        
        let presenter = MainPresenter(view: mainVC)
        mainVC.presenter = presenter
        mainVC.parchment = mainView
        return navVC
    }
    
    func createFavouriteModule(mainView: PageScrollViewController) -> UIViewController {
        let favVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavouritesVC") as FavouriteViewController
        let navVC = UINavigationController(rootViewController: favVC)
        
        let presenter = FavouritePresenter(view: favVC)
        favVC.presenter = presenter
        favVC.parchment = mainView
        return navVC
    }
    
    func createChartModule(ticker: String, company: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChartVC") as! ChartViewController
        let presenter = ChartPresenter(view: vc, ticker: ticker, company: company)
        vc.presenter = presenter

        return vc
    }
    
    func createSummaryModule(ticker: String, company: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryVC") as! SummaryViewController
        let presenter = SummaryPresenter(view: vc, ticker: ticker, company: company)
        vc.presenter = presenter
        
        return vc
    }
    
    func createNewsModule(ticker: String, company: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsVC") as! NewsViewController
        let presenter = NewsPresenter(view: vc, ticker: ticker, company: company)
        vc.presenter = presenter
        
        return vc
    }
    
 }
