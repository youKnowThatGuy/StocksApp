//
//  NewsViewController.swift
//  StocksApp
//
//  Created by Клим on 29.03.2021.
//

import UIKit
import SafariServices

protocol NewsViewProtocol: UIViewController{
    func updateUI()
}

class NewsViewController: UIViewController, SFSafariViewControllerDelegate {
    var presenter: NewsPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        updateUI()
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
   {
       controller.dismiss(animated: true, completion: nil)
   }
    
}

extension NewsViewController: NewsViewProtocol{
    func updateUI() {
        tableView.reloadData()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.newsCount()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: URL(string: presenter.getNewsUrl(index: indexPath.row))!)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsViewCell.identifier) as! NewsViewCell
        presenter.prepareCell(cell: cell, index: indexPath.row)
        return cell
    }
}
