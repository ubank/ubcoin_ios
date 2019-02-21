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
        guard let status = deal?.currentStatus else { return "" }
        
        return status.longTitle
    }
    
    var longStatusDesc: String? {
        if isPurchase {
            guard let status = deal?.currentStatus else { return "" }
            
            return status.longDesc
            
        } else if item?.isDigital == true {
            return "str_purchase_process_desc".localizedString()
        } else {
            return ""
        }
    }
    
    var actionButtonTitle: String {
        if canCancelDeal {
            return "str_cancel_the_deal".localizedString()
        }
        return "str_report_problems".localizedString()
    }
    
    var canCancelDeal: Bool {
        if let status = deal?.status,
            (status == DEAL_STATUS_DELIVERY || status == DEAL_STATUS_CONFIRMED) {
            return false
        }
        return item?.isDigital == false
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
