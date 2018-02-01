//
//  GDAX.swift
//  Tangle
//
//  Created by Michael Lema on 1/21/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class GDAXProduct {
    init(product: String) {
        //:  Examples: 'LTC-USD', 'BTC-USD', 'ETH-USD'...
        let productURL = "https://api.gdax.com/products/\(product)/candles"
        let url = URL(string: productURL)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }

            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Array<Any>]

                /*
                 [
                    [ time, low, high, open, close, volume ],
                    [ 1415398768, 0.32, 4.2, 0.35, 4.2, 12.3 ],
                 ...
                 ]
                */

                //print(jsonArray)
                for array in jsonArray {
                    let unixTimeStamp = array[0] as! Double
                    let date = Date(timeIntervalSince1970: unixTimeStamp)
                    //print(date)


                    print(date, array[1])
                }

            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        /*
        var urlComponents = URLComponents(string: productURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "start", value: String(1516792800)),
            URLQueryItem(name: "end", value: String(1516879200)),
            URLQueryItem(name: "granularity", value: String(60))
        ]
        print(urlComponents.url!)
         https://api.gdax.com/products/LTC-USD/candles?start:1517036760&end:1517015760&granularity:300
 */
    }
    
    func fetch(start: Date, end: Date, granularity: Int) {
        /*
 Fetch the candle data for a given range and granularity.
 
 Args:
 start (datetime): The start of the date range.
 end (datetime): The end of the date range (excluded).
 granularity (int): The granularity of the candles data (in minutes). || Desired timeslice in seconds
         /* The granularity field must be one of the following values: {60, 300, 900, 3600, 21600, 86400}
 
         Otherwise, your request will be rejected. These values correspond to timeslices representing one minute, five minutes, fifteen minutes, one hour, six hours, and one day, respectively.
         */
*/
        let data = [Any]()
        //: We will fetch the candle data in windows of maximum 100 items.
        //: GDAX has a limit of returning maximum of 200, per request.
        let timeLapse = granularity * 60
        
    }
   
    
    
}
