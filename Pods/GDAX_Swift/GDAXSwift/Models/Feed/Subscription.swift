//
//  Subscription.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 09/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class Subscription: NSObject {
    public var products: [String] = []
    public var id: String = UUID().uuidString
    public var channel: FeedType = .ticker

    public func unsubscribe() {
        for product in products {
            GDAX.feed.disconectFrom(channel: channel, product: "\(id).\(product)")
        }
    }
}
