//
//  Account.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 07/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class Account: Codable {
    public var id: String?
    public var currency: String?
    public var balance: String?
    public var available: String?
    public var hold: String?
    public var profile_id: String?
}
