//
//  LeftCryptoController.swift
//  Tangle
//
//  Created by Michael Lema on 1/20/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Charts

class LeftCryptoController: UIViewController, UIScrollViewDelegate {
    
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
        imageView.image = #imageLiteral(resourceName: "Litecoin Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //: TODO: Change font
    let marketPrice: UILabel = {
        let label = UILabel()
        label.text = "$207.43"
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont(name: "Avenir-Heavy", size: 52)
        return label
    }()
    
    let marketChange: UILabel = {
        let label = UILabel()
        label.text = "6.05 %"
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont(name: "Avenir-Light", size: 34)
        return label
    }()
    let litecoinChart: LineChartView = {
        let chart = LineChartView()
        //chart.backgroundColor = .red
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.68, green: 0.68, blue: 0.69, alpha: 0.5)
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(marketPrice)
        contentView.addSubview(marketChange)
        
        
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
        contentView.addConstraint(NSLayoutConstraint(item: marketChange, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //: Vertical Constraints
        contentView.addConstraintsWithFormat(format: "V:|-45-[v0]-5-[v1][v2]", views: imageView, marketPrice, marketChange)
    }
    
    
}
