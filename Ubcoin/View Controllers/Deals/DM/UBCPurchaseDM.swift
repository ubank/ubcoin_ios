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
    
    
    var itemDisplayPrice : String {
        guard let item = item else {
            return ""
        }
        var itemPriceString = String(format: "%@ UBC / %@ ETH", item.price.priceString, item.priceInETH.coinsPriceString)
        
        if let deal = deal {
            if deal.currencyType == "UBC" {
                itemPriceString = item.price.priceString + " " + deal.currencyType
            }
            if deal.currencyType == "ETH" {
                itemPriceString = item.priceInETH.coinsPriceString + " " + deal.currencyType
            }
        }
        
        return itemPriceString
    }
    
    var confirmButtonTitle : String {
        return isNeedShowForMeetingItem || isNeedShowForDeliveryItem  ? "str_received_item_ok".localizedString() : "str_confirm_file_ok".localizedString()
    }
    
    var isNeedShowForDigitalItem : Bool {
        guard let item = item, let deal = deal else {
            return false
        }
        
        return item.isDigital && deal.status == DEAL_STATUS_ACTIVE && !item.isMyItem
    }
    
    var isNeedShowForMeetingItem : Bool {
        guard let item = item, let deal = deal, item.isDigital == false else {
            return false
        }
        
        return isPurchase && deal.status == DEAL_STATUS_ACTIVE && !item.isMyItem && deal.withDelivery == false
    }
    
    var isNeedShowForDeliveryItem : Bool {
        
        guard let item = item, let deal = deal, item.isDigital == false else {
            return false
        }
        
        return isPurchase && deal.status == DEAL_STATUS_DELIVERY && !item.isMyItem && deal.withDelivery
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
    
    var isCanceled: Bool {
        if let status = deal?.status, status == DEAL_STATUS_CANCELLED {
            return true
        }
        return false
    }
    
    var deliveryImage: UIImage? {
        var imageName = "deliverBookedTime"
        
        if let deal = deal {
            if deal.status == DEAL_STATUS_DELIVERY {
                imageName = "deliverInProccess"
            }
            else if deal.status == DEAL_PRICE_CONFIRMED{
                imageName = "deliverFroze"
            }
            else if deal.status == DEAL_STATUS_CONFIRMED {
                imageName = "deliverIsConfirmed"
            }
            else if deal.status == DEAL_STATUS_CANCELLED {
                imageName = ""
            }
        }
        

        return UIImage(named: imageName)
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
    
    @objc convenience init(item: UBCGoodDM, deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
        self.item = item
        self.isPurchase = true
    }
}
