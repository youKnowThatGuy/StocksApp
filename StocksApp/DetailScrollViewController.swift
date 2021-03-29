//
//  DetailScrollViewController.swift
//  StocksApp
//
//  Created by Клим on 28.03.2021.
//

import UIKit
import Parchment

class DetailScrollViewController: UIViewController {
    let mod = ModuleBuilder()
    var data = ""
    var stockTicker = ""
    var company = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        unpackData()
        let firstViewController = mod.createChartModule(ticker: stockTicker, company: company)
        let secondViewController = mod.createSummaryModule(ticker: stockTicker, company: company)
        let thirdViewController = mod.createNewsModule(ticker: stockTicker, company: company)
            let pagingViewController = PagingViewController(viewControllers: [
              firstViewController,
              secondViewController, thirdViewController
            ])
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.menuInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: -10, right: 0)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 50, height: 105)
        pagingViewController.font = UIFont.init(descriptor: UIFontDescriptor(name: "Rockwell", size: 18), size: 18)
        pagingViewController.selectedFont = UIFont.init(descriptor: UIFontDescriptor(name: "Rockwell", size: 18), size: 18)

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
        
    }
    
    func unpackData(){
        let dataComp = data.components(separatedBy: ";")
        stockTicker = dataComp[0]
        company = dataComp[1]
    }


}

