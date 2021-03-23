//
//  MainViewController.swift
//  StocksApp
//
//  Created by Клим on 11.03.2021.
//

import UIKit

protocol MainViewProtocol: UIViewController{
    func updateUI()
    func clearUI()
    var resultsTableViewController: SearchStocksViewController {get}
}

class MainViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var timer: Timer!
    
    var searchController: UISearchController!
    var resultsTableController: SearchStocksViewController!
    
    var presenter: MainPresenterProtocol!
    
    @IBAction func returnToMainButton(_ sender: Any) {
        setupTimer()
        presenter.switchSearch()
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.connectToSocket()
        presenter.loadRecentSearches()
        setupSearchBar()
        setupTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        presenter.loadFavourites()
    }
    
    func setupTimer(){
        timer = Timer.scheduledTimer(
          timeInterval: 2.0, target: self, selector: #selector(getData),
          userInfo: nil, repeats: true)
    }
    
    
    @objc private func getData(){
        presenter.getData()
    }
    
    
    private func setupSearchBar(){
        resultsTableController = SearchStocksViewController()
        resultsTableController.suggestedSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func setToSuggestedSearches() {
        resultsTableController.showSuggestedSearches = true
        resultsTableController.tableView.delegate = resultsTableController
    }
    
    func saveRecentSearch(query: String){
       resultsTableController.updateSearchTable(newSearch: query)
        presenter.saveRecentSearch(query: resultsTableController.suggestedSearches.joined(separator: ", "))
       
   }
}



extension MainViewController: MainViewProtocol{
    func clearUI() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
    }
    
    var resultsTableViewController: SearchStocksViewController {
        get {
            resultsTableController
        }
    }
    
    func updateUI(){
       DispatchQueue.main.async {
        self.tableView.reloadData()
       }
   }
}

extension MainViewController: SuggestedSearch{
    func didSelectSuggestedSearch(word: String) {
        let searchField = searchController.searchBar
        if (searchField.text == word){
           searchController.dismiss(animated: true, completion: nil)
           resultsTableController.showSuggestedSearches = false
           return
       }
        searchField.text = word
        presenter.loadStocks(query: word)
       searchController.dismiss(animated: true, completion: nil)
       resultsTableController.showSuggestedSearches = false
    }
}

extension MainViewController: UISearchControllerDelegate{
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}

extension MainViewController: UISearchBarDelegate{
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count >= 2 else{
            return
        }
        presenter.loadStocks(query: query)
        timer.invalidate()
        saveRecentSearch(query: query)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            resultsTableController.showSuggestedSearches = false
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stockCount()
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
