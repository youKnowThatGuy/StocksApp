//
//  PageScrollViewController.swift
//  StocksApp
//
//  Created by Клим on 28.03.2021.
//

import Parchment
import UIKit

class PageScrollViewController: UIViewController {
    let mod = ModuleBuilder()
    
    private var pagingViewController: PagingViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstViewController = mod.createMainModule(mainView: self)
        let secondViewController = mod.createFavouriteModule(mainView: self)
             pagingViewController = PagingViewController(viewControllers: [
              firstViewController,
              secondViewController
            ])
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.menuInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: -10, right: 0)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 50, height: 95)
        pagingViewController.font = UIFont.init(descriptor: UIFontDescriptor(name: "Rockwell", size: 18), size: 18)
        pagingViewController.selectedFont = UIFont.init(descriptor: UIFontDescriptor(name: "Rockwell", size: 18), size: 18)

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
    }
    func hideMenu(){
        pagingViewController.menuInsets = UIEdgeInsets.init(top: 50, left: 0, bottom: 0, right: 0)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 150, height: 30)
        pagingViewController.menuBackgroundColor = UIColor.systemGray6
    }
    
    func showMenu(){
        pagingViewController.menuInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: -10, right: 0)
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 50, height: 95)
        pagingViewController.menuBackgroundColor = UIColor.white
        
    }



}
