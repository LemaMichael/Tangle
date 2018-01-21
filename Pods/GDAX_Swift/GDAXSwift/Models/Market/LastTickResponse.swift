//
//  LastTickResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 10/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class LastTickResponse: Codable {

    public var trade_id: Int?
    public var price: String?
    public var size: String?
    public var bid: String?
    public var ask: String?
    public var volume: String?
    public var time: String?

}
