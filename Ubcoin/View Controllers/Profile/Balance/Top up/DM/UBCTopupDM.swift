//
//  UBCTopupDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCTopupDM: NSObject {

    var address: String
    var qrCodeURL: String
    var walletExpirationDate: NSDate
    
    @objc
    init?(dictionary: [String: Any]) {
        guard let address = dictionary["ubCoinAddress"] as? String,
            let qrCodeURL = dictionary["qrURL"] as? String,
            let walletExpirationDate = NSDate.init(from: dictionary["finishUsage"] as? String, inFormat: "yyyyMMdd'T'HHmmssZ") else {
                return nil
        }
        
        self.address = address
        self.qrCodeURL = qrCodeURL
        self.walletExpirationDate =  walletExpirationDate
    }
}
