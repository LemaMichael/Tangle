//
//  Authenticate.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 07/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import CryptoSwift


open class Authenticate: NSObject {
    typealias  CompletionType<T> = (_ result:T?,_ error: Error?) -> Void
    static let client = Authenticate()
    private let queue = OperationQueue()
    private let session:URLSession

    public var CB_ACCESS_KEY = UserDefaults.standard.string(forKey: "CB_ACCESS_KEY") ?? ""
    public var CB_ACCESS_SIGN = UserDefaults.standard.string(forKey: "CB_ACCESS_SIGN") ?? ""
    public var CB_ACCESS_PASSPHRASE = UserDefaults.standard.string(forKey: "CB_ACCESS_PASSPHRASE") ?? ""

    private override init() {
        let config = URLSessionConfiguration.default
        guard CB_ACCESS_SIGN != "" else {
            fatalError("Init your credentials")
        }
        config.httpAdditionalHeaders = ["CB-ACCESS-KEY": CB_ACCESS_KEY,
                                        "CB-ACCESS-PASSPHRASE":CB_ACCESS_PASSPHRASE]

        queue.name = "authenticate_queue"
        session = URLSession(configuration: config, delegate: nil, delegateQueue: queue)
        super.init()
    }

    private func createRequest(path: String, query: String? = nil, method:String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string:"\(BASE_URL)\(path)\(query ?? "")")!)
        let timestamp = Int64(Date().timeIntervalSince1970)

        request.addValue("\(timestamp)", forHTTPHeaderField: "CB-ACCESS-TIMESTAMP")
        request.httpMethod = method.uppercased()
        if method.uppercased() == "POST" {
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = body
        }
        let what = "\(timestamp)\(method.uppercased())\(path)\(body != nil ? String(data: request.httpBody!, encoding: .utf8)! : "")".data(using: .utf8)
        let key = Data(base64Encoded:CB_ACCESS_SIGN)
        do {
            let sign = try HMAC(key: key!.bytes, variant: .sha256).authenticate(what!.bytes).toBase64()
            request.addValue(sign!, forHTTPHeaderField: "CB-ACCESS-SIGN")
        } catch {

        }

        return request
    }

    private func performRequest<T:Codable>(path: String, method: String, body: Data? = nil, completion: @escaping CompletionType<T>) {
        session.dataTask(with: createRequest(path: path, method: method, body: body)) { (data, response, error) in
            let k = self.parse(object: T.self, data: data, error: error)
            completion(k, error)
            }.resume()
    }

    private func parse<T:Codable>(object:T.Type, data:Data?, error:Error?) -> T? {
        guard error == nil else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let k = try decoder.decode(object, from: data!)

            return k
        } catch {
            return nil
        }
    }

    public func getAccounts(completion:@escaping (_ accounts: [Account]?,_ error:Error?) -> Void) {
        performRequest(path: "/accounts", method: "GET", completion: completion)
    }

    public func getAccount(accountId: String, completion:@escaping (_ account: Account?,_ error:Error?) -> Void)  {
        performRequest(path: "/accounts/\(accountId)", method: "GET", completion: completion)
    }

    public func getAccountHistory(accountId: String, completion:@escaping (_ activities: [Activity]?, _ error:Error?) -> Void)  {
        performRequest(path: "/accounts/\(accountId)/ledger", method: "GET", completion: completion)
    }

    public func getAccountHolds(accountId: String, completion:@escaping (_ holds: [Hold]?,_ error:Error?) -> Void)  {
        performRequest(path: "/accounts/\(accountId)/holds", method: "GET", completion: completion)
    }

    public func getOrders(status: String, product_id: String? = nil, completion: @escaping(_ order: [OrderResponse]?, _ error: Error?) -> Void) {
        performRequest(path:"/orders?status=\(status)\(product_id != nil ? "&product_id=\(product_id!)" : "")", method: "GET", completion: completion)
    }

    public func getOrder(orderId: String, completion: @escaping(_ order: OrderResponse?, _ error: Error?) -> Void) {
        performRequest(path: "/orders/\(orderId)", method: "GET", completion: completion)
    }

    public func postOrder(order: Order, completion: @escaping(_ order: OrderResponse?, _ error: Error?) -> Void) {
        do {
           let body = try JSONEncoder().encode(order)
            performRequest(path:  "/orders", method: "POST", body: body, completion: completion)
        } catch  {

        }
    }

    public func cancelOrder(orderId:String, completion: @escaping(_ canceledOrder:[String]?,_ error: Error?) -> Void) {
        performRequest(path: "/orders/\(orderId)", method: "DELETE", completion: completion)
    }

    public func cancelAllOrders(completion: @escaping(_ canceledOrder:[String]?,_ error: Error?) -> Void) {
       performRequest(path: "/orders", method: "DELETE", completion: completion)
    }
}
