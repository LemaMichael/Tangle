//
//  StatResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 11/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class StatResponse: Codable {
    public var open: String?
    public var high: String?
    public var low: String?
    public var volume: String?
    public var last: String?
    public var volume_30day: String?

}
