//
//  UserDefaultsExtension.swift
//  Tangle
//
//  Created by Michael Lema on 1/23/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    enum UserDefaultKeys: String {
        case hasLTC, hasBTC, hasETH
    }
    
    func setLTCAmount(value: Float)  {
        set(value, forKey: UserDefaultKeys.hasLTC.rawValue)
        synchronize()
    }
    func availableLTC() -> Float {
        return float(forKey: UserDefaultKeys.hasLTC.rawValue)
    }
    func setBTCAmount(value: Float)  {
        set(value, forKey: UserDefaultKeys.hasBTC.rawValue)
        synchronize()
    }
    func availableBTC() -> Float {
        return float(forKey: UserDefaultKeys.hasBTC.rawValue)
    }
    func setETHAmount(value: Float)  {
        set(value, forKey: UserDefaultKeys.hasETH.rawValue)
        synchronize()
    }
    func availableETH() -> Float {
        return float(forKey: UserDefaultKeys.hasETH.rawValue)
    }
    
}
