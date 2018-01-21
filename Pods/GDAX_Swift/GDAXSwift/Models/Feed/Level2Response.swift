//
//  Level2Response.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 05/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class Level2Response: Codable {
    public var product_id: String?
    public var changes: [[String]]?
}
