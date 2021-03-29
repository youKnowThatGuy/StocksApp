//
//  ChartViewController.swift
//  StocksApp
//
//  Created by Клим on 27.03.2021.
//

import UIKit
import Charts

protocol ChartViewProtocol: UIViewController{
    func updateUI()
}

class ChartViewController: UIViewController, ChartViewDelegate {
    var presenter: ChartPresenterProtocol!
    
    var candleChart = CandleStickChartView()
    
    @IBOutlet weak var tickerLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var changePriceLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var intervalShell: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        tickerLabel.text = presenter.stockTicker
        companyLabel.text = presenter.company
        candleChart.delegate = self
        errorLabel.isHidden = true
        
        _ = Timer.scheduledTimer(
          timeInterval: 2.0, target: self, selector: #selector(getData),
          userInfo: nil, repeats: true)
        setupChartTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        presenter.connectToSingleSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        presenter.disconnectToSingleSocket()
    }
    
    @IBAction func intervalChosen(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            presenter.choice = 0
        case 1:
            presenter.choice = 1
        case 2:
            presenter.choice = 2
        case 3:
            presenter.choice = 3
        case 4:
            presenter.choice = 4
        case 5:
            presenter.choice = 5
        default:
            print("")
        }
        prepareChart()
    }
    
    func setupChartTimer(){
        _ = Timer.scheduledTimer(
            timeInterval: 3.0, target: self, selector: #selector(prepareChart),
            userInfo: nil, repeats: false)
    }
    
    @objc func prepareChart(){
        let chartData = presenter.getChartData()
        
        if chartData != nil{
        candleChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.4, height: self.view.frame.size.width / 1.4)
        view.addSubview(candleChart)
        setupChartLayout()
        candleChart.data = chartData
        
        candleChart.legend.enabled = false
        candleChart.xAxis.drawAxisLineEnabled = false
        candleChart.xAxis.drawGridLinesEnabled = false
        candleChart.leftAxis.drawGridLinesEnabled = false
        candleChart.leftAxis.drawAxisLineEnabled = false
            candleChart.leftAxis.drawTopYLabelEntryEnabled = false
            candleChart.xAxis.drawLabelsEnabled = false
            
        }
        else{
            errorLabel.isHidden = false
            intervalShell.isHidden = true
        }
    }
    
    private func setupChartLayout() {
        let margins = view.layoutMarginsGuide
        candleChart.translatesAutoresizingMaskIntoConstraints = false
        candleChart.topAnchor.constraint(equalTo: margins.topAnchor, constant: 213).isActive = true
        candleChart.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85).isActive = true
        
        candleChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        candleChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        candleChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true //right
        candleChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true //left
    }
    
    
    @objc func getData(){
        presenter.getData()
    }

}

extension ChartViewController: ChartViewProtocol{
    func updateUI() {
        DispatchQueue.main.async {  [self] in
            priceLabel.text = "$\(presenter.currPrice)"
            let change = presenter.change
        if change > 0{
            changePriceLabel.textColor = UIColor.systemGreen
            changePriceLabel.text = "+$\(presenter.change)"
        }
        else{
            changePriceLabel.textColor = UIColor.systemRed
            changePriceLabel.text = "$\(presenter.change)"
        }
        }
    }
    
    
}
