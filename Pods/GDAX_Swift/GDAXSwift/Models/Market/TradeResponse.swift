//
//  TradeResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 06/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class TradeResponse: Codable {
    public var time: String?
    public var trade_id: Int?
    public var price: String?
    public var size: String?
    public var side: String?
    
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
