//
//  Response.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

public enum FeedType: String {
    case heartbeat, ticker, l2update, full, subscriptions
}

class Response: Codable {
    var type: String?
}
