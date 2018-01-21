//
//  HeartbeatResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 05/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class HeartbeatResponse: Codable {
    public var sequence: Int?
    public var last_trade_id: Int?
    public var product_id: String?
}
