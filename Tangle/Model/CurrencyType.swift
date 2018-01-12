//
//  CurrencyType.swift
//  Tangle
//
//  Created by Michael Lema on 1/12/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

//: Stores a name and value for each crypto
enum CurrencyType: String {
    case btc = "BTC",
    eth = "ETH",
    ltc = "LTC",
    xrp = "XRP",
    xmr = "XMR",
    neo = "NEO"
    
    //: Our enum cases have a rawVlue associated with them mapping to each of the 6 cryptos
    //: By leveraging the rawValue we can now get the respective URL for any Crypto we add to the enum
    var apiURL: URL? {
        let apiString = "https://min-api.cryptocompare.com/data/price?fsym=" + rawValue + "&tsyms=USD"
        return URL(string: apiString)
    }
    
    //: To display the name of the crypto within the cell
    //: This will allow us to get the name back for a CurrencyType as a String.
    var name: String {
        switch self {
        case .btc:
            return "Bitcoin"
        case .eth:
            return "Ethereum"
        case .ltc:
            return "Litecoin"
        case .xrp:
            return "Ripple"
        case .xmr:
            return "Monero"
        case .neo:
            return "Neo"
        }
    }
    
    //: We are using a completion block because a URLRequest is a background operation, meaning that the UI work of rendering the app occurs while the function is operating.
    func requestValue(completion: @escaping (_ value: NSNumber?) -> Void) {
        guard let apiURL = apiURL else {
            //: If we couldn't serialze the JSON set the value in the completion as nil and print the error
            completion(nil)
            print("URL Invalid")
            return
        }
        
        //: Lets start the request where dataTask returns Data from the call, a response (which returns information about the call), and an optional Error in the event of failure.
        let request = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            //: Get the data and return it
            guard let data = data, error == nil else {
                completion(nil)
                print(error?.localizedDescription ?? "")
                return
            }
            //: We now have the Data safely unwrapped. Now its time to fetch the USD value from the JSON response we got back.
            do {
                //: We use JSONSerialization which takes JSON Data and converts it into a Dictionary.
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any], let value = json["USD"] as? NSNumber else {
                    completion(nil)
                    return
                }
                completion(value)
            } catch {
                completion(nil)
                print(error.localizedDescription)
            }
            
        }
        request.resume()
    }
}
