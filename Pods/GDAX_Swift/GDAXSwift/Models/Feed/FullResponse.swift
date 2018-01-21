//
//  FullResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 21/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class FullResponse: Codable {
    public var type: String?
    public var time: String?
    public var product_id: String?
    public var sequence: Int?
    public var order_id: String?
    public var size: String?
    public var price: String?
    public var side: String?
    public var order_type: String?
    public var remaining_size: String?
    public var reason: String? //filled, // or canceled
    public var funds: String?
    public var trade_id: Int?
    public var maker_order_id: String?
    public var taker_order_id: String?
    public var new_size: String?
    public var old_size: String?
    public var new_funds: String?
    public var old_funds: String?
    public var nonce: Int?
    public var position: String?
    public var position_size: String?
    public var position_compliment: String?
    public var position_max_size: String?
    public var call_side: String?
    public var call_price: String?
    public var call_size: String?
    public var call_funds: String?
    public var covered: Bool?
    public var next_expire_time: String?
    public var base_balance: String?
    public var base_funding: String?
    public var quote_balance: String?
    public var quote_funding: String?
    public var _private: Bool?
    public var user_id: String?
    public var profile_id: String?
    public var taker_fee_rate: String?
    public var stop_type: String?
}
