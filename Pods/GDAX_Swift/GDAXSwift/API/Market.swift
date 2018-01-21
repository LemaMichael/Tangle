//
//  Public.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 06/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

var BASE_URL: String { return GDAX.debug ? "https://api-public.sandbox.gdax.com" : "https://api.gdax.com"}

open class Market: NSObject {
    static let client = Market()
    private let queue = OperationQueue()
    private let session:URLSession

    private override init() {
        let config = URLSessionConfiguration.default
        queue.name = "market_queue"
        session = URLSession(configuration: config, delegate: nil, delegateQueue: queue)
        super.init()
    }

    public func product(productId: String) -> Product {
        return Product(pID: productId)
    }

    public struct Product: Codable {
        var product_id: String
        init(pID: String) {
            product_id = pID
        }

        public func getTrades(completion: @escaping ([TradeResponse]?, Error?) -> Void) {
            let request = URLRequest(url: URL(string:"\(BASE_URL)/products/\(product_id)/trades")!)
            Market.client.session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    let resp = try JSONDecoder().decode([TradeResponse].self, from: data!)
                    completion(resp, error)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }

        public func get24hStats(completion: @escaping(StatResponse?, Error?) -> Void) {
            let request = URLRequest(url: URL(string:"\(BASE_URL)/products/\(product_id)/stats")!)
            Market.client.session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    let resp = try JSONDecoder().decode(StatResponse.self, from: data!)

                    completion(resp, error)
                } catch {
                    completion(nil, error)
                }
                }.resume()
        }


        public func getLastTick(completion:@escaping(LastTickResponse?, Error?) -> Void) {
            let request = URLRequest(url: URL(string:"\(BASE_URL)/products/\(product_id)/ticker")!)
            Market.client.session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    let resp = try JSONDecoder().decode(LastTickResponse.self, from: data!)
                    completion(resp, error)
                } catch {
                    completion(nil, error)
                }
                }.resume()
        }

        public func getBook(level:Int = 1, completion: @escaping(BookResponse)-> Void) {
            let request = URLRequest(url: URL(string:"\(BASE_URL)/products/\(product_id)/book\(level != 1 ? "?level=\(level)" : "")")!)
            Market.client.session.dataTask(with: request) { (data, response, error) in
                do {
                    let str = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any]
                    let resp = try JSONDecoder().decode(BookResponse.self, from: data!)
                    for (key, val) in str! {
                        if key == "bids" {
                            var elems:[baObject] = []
                            for v in val as! [[Any]] {

                                elems.append(baObject(price: v[0] as! String,
                                                      size: v[1] as! String,
                                                      order_id: v[2] is String ? v[2] as? String : nil,
                                                      num_order:v[2] is Int ? v[2] as? Int : nil))
                            }
                            resp.bids?.append(elems)
                        } else if key == "asks" {
                            var elems:[baObject] = []
                            for v in val as! [[Any]] {
                                elems.append(baObject(price: v[0] as! String,
                                                      size: v[1] as! String,
                                                      order_id: v[2] is String ? v[2] as? String : nil,
                                                      num_order:v[2] is Int ? v[2] as? Int : nil))
                            }
                            resp.asks?.append(elems)
                        }
                    }
                    completion(resp)
                } catch {
                    print("error")
                }

                }.resume()
        }
    }
}
