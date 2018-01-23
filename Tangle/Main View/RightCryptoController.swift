//
//  RightCryptoController.swift
//  Tangle
//
//  Created by Michael Lema on 1/20/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Charts
import GDAX_Swift

class RightCryptoController: UIViewController, UIScrollViewDelegate {
    
    var dataSource: [TickerResponse] = []
    let currencies = ["ETH-USD", "ETH-EUR"]
    
    lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .clear
        scrollview.showsVerticalScrollIndicator = false
        scrollview.alwaysBounceVertical = true
        scrollview.delegate = self
        return scrollview
    }()
    
    //: This view will contain the labels and chart
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Ethereum Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //: TODO: Change font
    let marketPrice: UIButton = {
        let button = UIButton()
        button.setTitle("$981.82", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.sizeToFit()
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 52)
        button.addTarget(self, action: #selector(currencyType), for: .touchUpInside)
        return button
    }()
    let ETH_balanceButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("ETH: 0", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.sizeToFit()
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 34)
        button.addTarget(self, action: #selector(holdAmount), for: .touchUpInside)
        return button
    }()
    
    let currencyBalance: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("USD: 0.00", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.sizeToFit()
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        //button.addTarget(self, action: #selector(NOTHING), for: .touchUpInside)
        return button
    }()
    
    lazy var ethereumChart: LineChartView = {
        let chart = LineChartView()
        //: TODO: - CHANGE THIS
        chart.backgroundColor = .clear
        chart.noDataText = ""
        chart.noDataTextColor = .clear
        return chart
    }()
    
    lazy var addressButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Address: 0x83D1085A4fAb21DeED36f34aed5c315e08b3a9CE", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 12)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(donationResponse), for: .touchUpInside)
        return button
    }()
    
    var currentCurrency: String = "ETH-USD" {
        didSet {
            print(oldValue)
            GDAX.feed.disconectFrom(channel: .ticker, product: oldValue)
            let values = currentCurrency.split(separator: "-")
            let from = gdax_products.init(rawValue: String(values[0]))
            let to = gdax_products.init(rawValue: String(values[1]))
            let _ = GDAX.feed.subscribeTicker(for: [gdax_value(from:from!, to: to!)]) { (tick) in
                self.refresh(tick: tick)
                self.dataSource.insert(tick, at: 0)
                //self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //: TODO: Change Color?
        view.backgroundColor = UIColor(red: 0.11, green: 0.15, blue: 0.18, alpha: 0.5)
        setupViews()
        connectToSocket()
        
        if !ETHAmount().isZero {
            self.ETH_balanceButton.setTitle("ETH: \(ETHAmount())", for: .normal)
        }
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(marketPrice)
        contentView.addSubview(ETH_balanceButton)
        contentView.addSubview(currencyBalance)
        contentView.addSubview(ethereumChart)
        contentView.addSubview(addressButton)
        
        
        //: USING SCROLL VIEW WITH AUTO LAYOUT IN 3 STEPS
        //: 1 - Set the scroll view constraints
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        
        //: 2 - set the content view (a subview of scroll view) constraints
        scrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        
        //: 3 - set equal width and height for the content view
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
        
        
        //: Logo Constraints
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 75))
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 75))
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //: MarketPrice Constraints
        contentView.addConstraint(NSLayoutConstraint(item: marketPrice, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //: MarketChange Constraints
        contentView.addConstraint(NSLayoutConstraint(item: ETH_balanceButton, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //: CurrencyBalance Constraints
        contentView.addConstraint(NSLayoutConstraint(item: currencyBalance, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //: Chart Constraints
        contentView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: ethereumChart)
        contentView.addConstraint(NSLayoutConstraint(item: ethereumChart, attribute: .bottom, relatedBy: .equal, toItem: addressButton, attribute: .top, multiplier: 1, constant: -10))
        
        
        //: Address Textfield Constraints
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: addressButton)
        contentView.addConstraintsWithFormat(format: "V:[v0(25)]|", views: addressButton)
        
        //: Vertical Constraints
        contentView.addConstraintsWithFormat(format: "V:|-45-[v0]-5-[v1][v2][v3]-5-[v4]", views: imageView, marketPrice, ETH_balanceButton, currencyBalance, ethereumChart)
    }
    
    func connectToSocket() {
        dataSource = []
        currentCurrency = "ETH-USD"
        GDAX.feed.onConnectionChange = []
        GDAX.feed.onConnectionChange?.append({ (connected) in
            if !connected {
                print("Not Connected!")
            } else {
                print("Connected!")
            }
        })
    }
    
    func refresh(tick: TickerResponse) {
        print("ETH Called")
        if (!ETHAmount().isZero) {
            if let floatPrice = tick.floatPrice {
                let price = tick.currentPriceFormatter.string(from: NSNumber(value: floatPrice * ETHAmount()))!
                //print(price)
                self.currencyBalance.setTitle("USD: " + price, for: .normal)
            } else {
                self.currencyBalance.setTitle("USD: 0.00" , for: .normal)
            }
        }
        self.marketPrice.setTitle(tick.formattedPrice, for: .normal)
    }
    
    //: MARK: - Button Targets
    @objc func holdAmount() {
        print("Hold amount tapped")
        let alertController = UIAlertController(title: "ETH Amount", message: "Enter size", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "0.8461"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            let textField = alertController.textFields![0] as UITextField
            let newAmount = textField.text!
            if !newAmount.isEmpty {
                //: Save the ETH coin input amount
                UserDefaults.standard.setETHAmount(value: newAmount.floatValue)
                self.refresh(tick: self.dataSource.first!)
                self.ETH_balanceButton.setTitle("ETH: " + newAmount, for: .normal)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func donationResponse() {
        let alertController = UIAlertController(title: "", message: "Address Copied!" , preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        //: Dismiss after a few seconds
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            //: Copy the address
            UIPasteboard.general.string = "0x83D1085A4fAb21DeED36f34aed5c315e08b3a9CE"
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func currencyType() {
        //: TODO: ADD Other currency support
        print("Curreny button tapped")
    }
    
    //: NSUSERDefaults
    fileprivate func ETHAmount() -> Float {
        return UserDefaults.standard.availableETH()
    }
    
}
