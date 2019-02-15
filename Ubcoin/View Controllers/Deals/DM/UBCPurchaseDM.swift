//
//  UBCPurchaseDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 29/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCPurchaseDM: NSObject {

    var isPurchase: Bool = false
    var item: UBCGoodDM?
    var deal: UBCDealDM?
    
    var longStatusTitle: String? {
        return ""
    }
    
    var longStatusDesc: String? {
        return "str_purchase_process_desc".localizedString()
    }
    
    var actionButtonTitle: String {
        return "str_cancel_the_deal".localizedString()
    }
    
    var seller: UBCSellerDM? {
        if let seller = item?.seller {
            return seller
        }
        return deal?.seller
    }
    
    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
    }
    
    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
        self.item = deal.item
        self.isPurchase = true
    }
}
