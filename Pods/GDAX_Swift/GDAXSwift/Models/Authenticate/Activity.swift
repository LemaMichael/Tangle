//
//  Activity.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 08/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

public struct ActivityDetail: Codable {
    public var order_id: String?
    public var trade_id: String?
    public var product_id: String?
}

open class Activity: Codable {

    public var id: String?
    public var created_at: String?
    public var amount: String?
    public var balance: String?
    public var type: String?
    public var details: ActivityDetail?

}
