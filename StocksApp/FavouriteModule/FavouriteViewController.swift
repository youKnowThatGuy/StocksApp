//
//  FavouriteViewController.swift
//  StocksApp
//
//  Created by Клим on 21.03.2021.
//

import UIKit

protocol FavouriteViewProtocol: UIViewController{
    func updateUI()
}

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavouritePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        /*
        _ = Timer.scheduledTimer(
          timeInterval: 4.0, target: self, selector: #selector(update),
          userInfo: nil, repeats: true)
 */
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        presenter.loadData()
        updateUI()
    }
    
    @objc func update(){
        updateUI()
    }
    

}

extension FavouriteViewController: FavouriteViewProtocol{
    func updateUI() {
        self.tableView.reloadData()
    }
}
    
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tickerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: StocksViewCell.identifier) as! StocksViewCell
        
        cell = presenter.prepareCell(cell: cell, index: indexPath.row)
        cell.checkTicker()
        
        if (indexPath.row).isMultiple(of: 2){
            cell.grayView()
        }
        return cell
    }
     
    
    }
    
    

