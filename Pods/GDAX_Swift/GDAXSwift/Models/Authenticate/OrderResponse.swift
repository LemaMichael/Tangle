//
//  OrderResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 08/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class OrderResponse: Codable {
    public var id: String?
    public var price: String?
    public var size: String?
    public var product_id: String?
    public var side: String?
    public var stp: String?
    public var type: String?
    public var time_in_force: String?
    public var post_only: Bool?
    public var created_at: String?
    public var fill_fees: String?
    public var filled_size: String?
    public var executed_value: String?
    public var status: String?
    public var settled: Bool?
}
