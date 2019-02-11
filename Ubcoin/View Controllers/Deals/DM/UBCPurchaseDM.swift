//
//  UBCPurchaseDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 29/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCPurchaseDM: NSObject {

    var item: UBCGoodDM?
    private var deal: UBCDealDM?
    
    var longStatusTitle: String? {
        get {
            return ""
        }
    }
    
    var longStatusDesc: String? {
        get {
            return "str_purchase_process_desc".localizedString()
        }
    }
    
    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
    }
    
    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
        self.item = deal.item
    }
}
