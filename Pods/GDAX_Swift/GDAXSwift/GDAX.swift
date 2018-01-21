//
//  GDAX.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 04/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class GDAX: NSObject {
    public static var debug = false
    public static var feed: Feed {return Feed.client }
    public static var market: Market { return Market.client }
    public static var isAuthenticated: Bool { return UserDefaults.standard.value(forKey: "CB_ACCESS_KEY") != nil }
    public static var authenticate:Authenticate { return Authenticate.client }

    public static func askForAuthentication(inVC:UIViewController, completion:@escaping(_ granted: Bool)-> Void) {
        if UserDefaults.standard.value(forKey: "CB_ACCESS_KEY") == nil  {
            func validateTF(textfields: [UITextField]) -> Bool {
                var res = true
                for tf in textfields {
                    res = res && tf.text != nil && tf.text != ""
                }
                return res
            }
            let alert = UIAlertController(title: "Enter your credentials", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (key) in
                key.placeholder = "Your API key"
            })
            alert.addTextField(configurationHandler: { (sign) in
                sign.placeholder = "Your secret"
            })
            alert.addTextField(configurationHandler: { (passphrase) in
                passphrase.placeholder = "Your passphrase"
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                let keyTf = alert.textFields![0] as UITextField
                let signTf = alert.textFields![1] as UITextField
                let passphraseTf = alert.textFields![2] as UITextField
                if validateTF(textfields: [keyTf, signTf, passphraseTf]) {
                    UserDefaults.standard.set(keyTf.text, forKey: "CB_ACCESS_KEY")
                    UserDefaults.standard.set(signTf.text, forKey: "CB_ACCESS_SIGN")
                    UserDefaults.standard.set(passphraseTf.text, forKey: "CB_ACCESS_PASSPHRASE")
                    completion(true)
                } else {
                    completion(false)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                completion(false)
            }))
            inVC.present(alert, animated: true, completion: nil)
        }
    }
}

