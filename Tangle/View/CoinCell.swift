//
//  CoinCell.swift
//  Tangle
//
//  Created by Michael Lema on 1/11/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class CoinCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.textAlignment = .left
        label.text = "Bitcoin"
        return label
    }()
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 12)
        label.textAlignment = .left
        label.text = "BTC"
        return label
    }()
    let coinPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 14)
        label.textAlignment = .right
        label.text = "$13,839.88"
        return label
    }()
    
    let dayChangePrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textAlignment = .right
        label.text = "-$775.98 (5.35%)"
        return label
    }()
    
    let priceChartLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 9)
        label.textColor = UIColor.rgb(red: 162, green: 168, blue: 170)
        label.textAlignment = .left
        label.text = "PRICE CHART"
        return label
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 162, green: 168, blue: 170)
        return view
    }()
    
    func setUpCell() {
        addSubview(coinLabel)
        addSubview(tickerLabel)
        addSubview(coinPrice)
        addSubview(dayChangePrice)
        addSubview(priceChartLabel)
        addSubview(borderView)
        
        //: CoinLabel Constraints
        addConstraintsWithFormat(format: "H:|-4-[v0]", views: coinLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]", views: tickerLabel)
        addConstraintsWithFormat(format: "V:|-4-[v0(19)]-2-[v1(14)]-3-[v2(10)]", views: coinLabel, tickerLabel, priceChartLabel)
        
        addConstraintsWithFormat(format: "H:[v0]-4-|", views: coinPrice)
        addConstraintsWithFormat(format: "H:[v0]-4-|", views: dayChangePrice)
        addConstraintsWithFormat(format: "V:|-4-[v0(20)]-2-[v1(14)]", views: coinPrice, dayChangePrice)

        addConstraintsWithFormat(format: "H:|-4-[v0]-2-[v1]|", views: priceChartLabel, borderView)
        addConstraint(NSLayoutConstraint(item: borderView, attribute: .centerY, relatedBy: .equal, toItem: priceChartLabel, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "V:[v0(0.5)]", views: borderView)
    }
}
