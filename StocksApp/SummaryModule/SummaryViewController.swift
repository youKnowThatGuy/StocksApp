//
//  SummaryViewController.swift
//  StocksApp
//
//  Created by Клим on 28.03.2021.
//

import UIKit
import SafariServices

protocol SummaryViewProtocol: UIViewController, SFSafariViewControllerDelegate{
    func updateUI()
}

class SummaryViewController: UIViewController {
    var presenter: SummaryPresenterProtocol!
    var url: String!
    
    @IBOutlet weak var countryLabel: UILabel!
   
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var exchangeLabel: UILabel!
    
    @IBOutlet weak var ipoLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var industryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(
          timeInterval: 1.0, target: self, selector: #selector(getData),
          userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        _ = Timer.scheduledTimer(
          timeInterval: 1.5, target: self, selector: #selector(reloadUI),
          userInfo: nil, repeats: false)
    }
    
    @objc func getData(){
        presenter.getData()
    }
    @objc func reloadUI(){
        updateUI()
    }
    
    @IBAction func urlButtonPressed(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: url)!)

        self.present(safariVC, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
   {
       controller.dismiss(animated: true, completion: nil)
   }
    
}

extension SummaryViewController: SummaryViewProtocol{
    func updateUI() {
        countryLabel.text = "Country: \(presenter.profile.country)"
        currencyLabel.text = "Currency: \(presenter.profile.currency)"
        exchangeLabel.text = "Exchange: \(presenter.profile.exchange)"
        ipoLabel.text = "IPO date: \(presenter.profile.ipo)"
        companyLabel.text = "Company: \(presenter.company)"
        industryLabel.text = "Industry: \(presenter.profile.finnhubIndustry)"
        url = presenter.profile.weburl
    }
    
    
}


