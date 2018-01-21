//
//  Feed.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import Starscream
import CryptoSwift

public enum gdax_products: String {
    case LTC, BTC, ETH, EUR, USD, BCH

    public func getProductId(for product: gdax_products) -> String {
        return "\(self.rawValue)-\(product.rawValue)"
    }
}


public struct GDAXProductsId {
    public static let LTC_EUR = gdax_products.LTC.getProductId(for: gdax_products.EUR)
    public static let LTC_USD = gdax_products.LTC.getProductId(for: gdax_products.USD)
    public static let LTC_BTC = gdax_products.LTC.getProductId(for: gdax_products.BTC)
    
    public static let BTC_EUR = gdax_products.BTC.getProductId(for: gdax_products.EUR)
    public static let BTC_USD = gdax_products.BTC.getProductId(for: gdax_products.USD)
    
    public static let ETH_EUR = gdax_products.ETH.getProductId(for: gdax_products.EUR)
    public static let ETH_USD = gdax_products.LTC.getProductId(for: gdax_products.USD)
    public static let ETH_BTC = gdax_products.ETH.getProductId(for: gdax_products.BTC)
}

public struct gdax_value {
    public var from: gdax_products
    public var to: gdax_products

    public init(from:gdax_products, to: gdax_products) {
        self.from = from
        self.to = to
    }

    public init(product_id: String) {
        let value = product_id.split(separator: "-")
        from = gdax_products(rawValue: String(value[0]))!
        to = gdax_products(rawValue: String(value[1]))!
    }

    func toString() -> String {
        return "\(from)-\(to)"
    }

}

open class Feed: NSObject {
    public typealias TickerHandler = (_ message: TickerResponse) -> Void
    public typealias HeartbeatHandler = (_ message: HeartbeatResponse) -> Void
    public typealias Level2Handler = (_ message: Level2Response) -> Void
    public typealias FullHandler = (_ message: FullResponse) -> Void

    public typealias ConnectionChangeHandler = ((_ connected: Bool) -> Void)
    private var requestedMessage: [String] = []
    private var tickerHandlers: [String: TickerHandler] = [:]
    private var heartbeatHandlers: [String: HeartbeatHandler] = [:]
    private var level2Handlers: [String: Level2Handler] = [:]
    private var fullHandlers: [String: FullHandler] = [:]

    private let ws = WebSocket(url: URL(string: "wss://ws-feed.gdax.com")!)
    private var openingSocket = false
    public static let client = Feed()
    public var errorHandler: ((_ error: Error?) -> Void)?
    public var isConnected: Bool { return ws.isConnected }

    public var onConnectionChange:[ConnectionChangeHandler]?
    public var user: authenticate = authenticate()

    
    private override init() {
        super.init()
        ws.onText = { message in
            guard let response = message.data(using: .utf8) else {
                return
            }
            let decoder = JSONDecoder()

            do {
                let k  = try decoder.decode(Response.self, from: response)
                guard let da2 = message.data(using: .utf8),
                    let chanType = k.type else {
                        return
                }
                let fType = FeedType(rawValue: chanType) ?? .full
                switch fType {
                case .ticker:
                    let tick = try decoder.decode(TickerResponse.self, from: da2)
                    let keys = self.tickerHandlers.keys.filter({ (key) -> Bool in
                        return key.contains(tick.product_id!)
                    })
                    for key in keys {
                        if let handler = self.tickerHandlers[key] {
                            handler(tick)
                        }
                    }

                    break
                case .heartbeat:
                    let heartbeat = try decoder.decode(HeartbeatResponse.self, from: da2)
                    let keys = self.heartbeatHandlers.keys.filter({ (key) -> Bool in
                        return key.contains(heartbeat.product_id!)
                    })
                    for key in keys {
                        if let handler = self.heartbeatHandlers[key] {
                            handler(heartbeat)
                        }
                    }
                    break
                case .l2update:
                    let l2update = try decoder.decode(Level2Response.self, from: da2)

                    let keys = self.level2Handlers.keys.filter({ (key) -> Bool in
                        return key.contains(l2update.product_id!)
                    })
                    for key in keys {
                        if let handler = self.level2Handlers[key] {
                            handler(l2update)
                        }
                    }
                    break

                case .full:
                    let full = try decoder.decode(FullResponse.self, from: da2)
                    let keys = self.fullHandlers.keys.filter({ (key) -> Bool in
                        return key.contains(full.product_id!)
                    })
                    for key in keys {
                        if let handler = self.fullHandlers[key] {
                            handler(full)
                        }
                    }
                    break
                case .subscriptions:
                    break
                }
            } catch {
                
            }
        }
        ws.onConnect = {
            self.openingSocket = false
            self.onConnectionChange?.forEach({ (handler) in
                handler(self.isConnected)
            })
            for msg in self.requestedMessage {
                self.ws.write(string: msg)
            }
        }
        ws.onDisconnect = { error in
            self.onConnectionChange?.forEach({ (handler) in
                handler(self.isConnected)
            })
            self.errorHandler?(error)
        }
        ws.connect()
        openingSocket = true
    }
    
    private func getSubscription(name: String, product: [String], authenticated: Bool? = nil) -> String {
        let timestamp = Int64(Date().timeIntervalSince1970)
        var sign:String? = nil
        if authenticated != nil {
            let method = "GET"
            let path = "users/self/verify"
            let what = "\(timestamp)\(method.uppercased())\(path)".data(using: .utf8)
            let key = Data(base64Encoded:Authenticate.client.CB_ACCESS_SIGN)

            do {
                sign = try HMAC(key: key!.bytes, variant: .sha256).authenticate(what!.bytes).toBase64()
            } catch {

            }
        }
        return """
        {
        \"type\": \"subscribe\",
        \"channels\": [{ \"name\": \"\(name)\", \"product_ids\": [\"\(product.joined(separator: "\",\""))\"]}]
        \(authenticated != nil ? ",\"signature\": \"\(sign!)\",\"key\": \"\(Authenticate.client.CB_ACCESS_KEY)\",\"passphrase\": \"\(Authenticate.client.CB_ACCESS_PASSPHRASE)\", timestamp:\(timestamp)" : "")
        }
        """
    }

    fileprivate func subscribe(_ prods: [String],_ name: String, authenticated: Bool? = nil) {
        let msg = getSubscription(name: name, product: prods, authenticated: authenticated)
        !ws.isConnected && !openingSocket ? ws.connect() : ()
        ws.isConnected ? ws.write(string: msg) : requestedMessage.append(msg)
    }

    public func subscribeTicker(for products: [gdax_value], responseHandler: @escaping TickerHandler) -> Subscription {
        let sub = Subscription()
        sub.channel = .ticker
        let prods:[String] = products.map({
            let prod = $0.from.getProductId(for: $0.to)
            sub.products.append(prod)
            let id = "\(sub.id).\(prod)"
            tickerHandlers[id] = responseHandler
            return prod
        })
        subscribe(prods, "ticker")
        return sub
    }
    
    public func subscribeHeartbeat(for products: [gdax_value], responseHandler: @escaping HeartbeatHandler) -> Subscription {
        let sub = Subscription()
        sub.channel = .heartbeat
        let prods:[String] = products.map({
            let prod = $0.from.getProductId(for: $0.to)
            sub.products.append(prod)
            let id = "\(sub.id).\(prod)"
            heartbeatHandlers[id] = responseHandler
            return prod
        })
        subscribe(prods, "heartbeat")
        return sub
    }

    public func subscribeLevel2(for products: [gdax_value], responseHandler: @escaping Level2Handler) -> Subscription {
        let sub = Subscription()
        sub.channel = .l2update
        let prods:[String] = products.map({
            let prod = $0.from.getProductId(for: $0.to)
            sub.products.append(prod)
            let id = "\(sub.id).\(prod)"
            level2Handlers[id] = responseHandler
            return prod
        })
        subscribe(prods, "level2")
        return sub
    }

    public func subscribeFull(for products: [gdax_value], responseHandler: @escaping FullHandler) -> Subscription {
        let sub = Subscription()
        sub.channel = .full
        let prods:[String] = products.map({
            let prod = $0.from.getProductId(for: $0.to)
            sub.products.append(prod)
            let id = "\(sub.id).\(prod)"
            fullHandlers[id] = responseHandler
            return prod
        })
        subscribe(prods, "full")
        return sub
    }

    public func disconectFrom(channel: FeedType, product: String) {
        switch channel {
        case .heartbeat:
            heartbeatHandlers.removeValue(forKey: product)
            break
        case .l2update:
            level2Handlers.removeValue(forKey: product)
            break
        case .ticker:
            tickerHandlers.removeValue(forKey: product)
            break
        case .full:
            fullHandlers.removeValue(forKey: product)
            break
        case .subscriptions:
            break
        }
    }

    open class authenticate {
        public func subscribeFull(for products: [gdax_value], responseHandler: @escaping FullHandler) -> Subscription? {
            guard GDAX.isAuthenticated else {
                return nil
            }
            let sub = Subscription()
            sub.channel = .full
            let prods:[String] = products.map({
                let prod = $0.from.getProductId(for: $0.to)
                sub.products.append(prod)
                let id = "\(sub.id).\(prod)"
                Feed.client.fullHandlers[id] = responseHandler
                return prod
            })
            Feed.client.subscribe(prods, "user", authenticated: true)
            return sub
        }

    }
}
