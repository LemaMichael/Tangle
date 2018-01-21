//
//  FormattedCurrency.swift
//  Tangle
//
//  Created by Michael Lema on 1/12/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

//: By making this an extension of NSNumber we can access the var from an NSNumber instance.
extension NSNumber {
    var formattedCurrencyString: String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter.string(from: self)
    }
}
