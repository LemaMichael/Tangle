//
//  Order.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 08/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class Order: Codable {
    public var size: String?
    public var price: String?
    public var side: String?
    public var type: String?
    public var stp: String?
    public var product_id: String?
    public var time_in_force: String?
    public var cancel_after: String?
    public var post_only: Bool?

    public init() {

    }
}
