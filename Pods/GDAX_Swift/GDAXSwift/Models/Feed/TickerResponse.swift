//
//  TickerResponse.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class TickerResponse: Codable {
    public var time: String?
    public var sequence:Int?
    public var price:String?
    public var product_id: String?
    public var trade_id: Int?
    public var side: String?
    public var last_size: String?
    public var best_bid: String?
    public var best_ask: String?

    public var floatPrice: Float? {
        return Float(price!)
    }

    public var formattedPrice: String {
        return currentPriceFormatter.string(from: NSNumber(value: floatPrice!)) ?? "Unavailable"
    }

    public var currentPriceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencyCode = product_id != nil && product_id!.contains("USD") ? "USD" : "EUR"
        return formatter
    }

    public var formattedDate: String? {
        if let time = time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
            let date = dateFormatter.date(from: time)

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm:ss"
            return outputFormatter.string(from: date!)
        }
        return nil
    }
}
