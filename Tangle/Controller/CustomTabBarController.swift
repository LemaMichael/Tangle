//
//  CustomTabBarController.swift
//  Tangle
//
//  Created by Michael Lema on 1/11/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //: TODO Add Viewcontrollers here later
        let portfolioController = PortfolioController()
        //portfolioController.navigationItem.title = "Portfolio"
        let firstNavController = UINavigationController(rootViewController: portfolioController)
        firstNavController.title = "Porfolio"
       // firstNavController.tabBarItem.image =
        
        viewControllers = [firstNavController]
        
        //: Change tabBarController's transparency
        tabBar.isTranslucent = false
        
        //: Change height of tabBar's Line to 0.5 Pixels
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.gray.cgColor

        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
}
