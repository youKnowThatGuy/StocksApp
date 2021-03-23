//
//  ModuleBuilder.swift
//  StocksApp
//
//  Created by Клим on 12.03.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController
    func createFavouriteModule() -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol{
    func createMainModule() -> UIViewController {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavVC") as UINavigationController
        let vc = navVC.children[0]
        vc.removeFromParent()
        
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StocksMain") as MainViewController
        
        navVC.addChild(mainVC)
        
        let presenter = MainPresenter(view: mainVC)
        mainVC.presenter = presenter
        return navVC
    }
    
    func createFavouriteModule() -> UIViewController {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavouriteNavVC") as UINavigationController
        let vc = navVC.children[0]
        vc.removeFromParent()
        
        let favVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavouritesVC") as FavouriteViewController
        
        let presenter = FavouritePresenter(view: favVC)
        favVC.presenter = presenter
        navVC.addChild(favVC)
        return navVC
    }
    
 }
