//
//  StringExtension.swift
//  Tangle
//
//  Created by Michael Lema on 1/21/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
