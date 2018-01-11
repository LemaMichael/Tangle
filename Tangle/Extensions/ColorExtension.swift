//
//  ColorExtension.swift
//  Tangle
//
//  Created by Michael Lema on 1/11/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
