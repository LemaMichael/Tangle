//
//  Hold.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 08/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class Hold: Codable {
    public var id: String?
    public var account_id: String?
    public var created_at: String?
    public var updated_at: String?
    public var amount: String?
    public var type: String?
    public var ref: String?
}
