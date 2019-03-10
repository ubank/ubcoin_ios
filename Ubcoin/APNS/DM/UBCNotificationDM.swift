//
//  UBCNotificationDM.swift
//  Ubcoin
//
//  Created by vkrotin on 10.03.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

public enum UBCNotificationConst {
    static let kChat = "kSaveChatEventNotification"
    static let kDealItem = "kSaveDealItemEventNotification"
    static let kDealItemArray = "kSaveDealItemKeyEventNotification"
}


@objc class UBCNotificationDM: NSObject {
    
    
    @objc class var needShowChatBadge: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UBCNotificationConst.kChat)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UBCNotificationConst.kChat)
            UserDefaults.standard.synchronize()
            
            badgeForMessagesListController(newValue)
        }
    }
    
    @objc class var needShowDealItemBadge: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UBCNotificationConst.kDealItem)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UBCNotificationConst.kDealItem)
            UserDefaults.standard.synchronize()
            
            badgeForDealsController(newValue)
        }
    }
    
    class var arrayDeals: [String]? {
        get {
            return UserDefaults.standard.value(forKey: UBCNotificationConst.kDealItemArray) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UBCNotificationConst.kDealItemArray)
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc static func saveDealStatusChange(_ deal: String?) {
        
        if isContainsDeal(deal) {
            return
        }
        
        var deals:[String] = []
        if let saveDeals = arrayDeals {
            deals.append(contentsOf: saveDeals)
        }
        
        if let deal = deal, deal.count > 0 {
            deals.append(deal)
            arrayDeals = deals
        }
    }
    
    @objc static func isContainsDeal(_ dealId: String?) -> Bool {
        guard let array = arrayDeals, let dealId = dealId else {
            return false
        }
        
        return array.contains(dealId)
    }
    
    @objc static func removeSaveDeal(_ dealId: String?) {

        guard var array = arrayDeals, let dealId = dealId, let index = array.index(of: dealId) else {
            return
        }

        array.remove(at: index)
        arrayDeals = array
    }
    
    private class func badgeForMessagesListController(_ isShow: Bool) {
        if let delegate = UIApplication.shared.delegate as? UBCAppDelegate,
        let tab = delegate.navigationController.viewControllers.first as? UITabBarController,
            let controll = tab.viewControllers?.filter({ $0 is UBCMessagesListController }).first as? UBViewController  {
            controll.tabBarItem.badgeValue = isShow ? "" : nil
            
//            if delegate.navigationController.currentController is UBCMessagesListController {
//                delegate.navigationController.currentController .updateInfo()
//            }
        }
    }

    private class func badgeForDealsController(_ isShow: Bool) {
        if let delegate = UIApplication.shared.delegate as? UBCAppDelegate,
            let tab = delegate.navigationController.viewControllers.first as? UITabBarController,
            let controll = tab.viewControllers?.filter({ $0 is UBCProfileController }).first as? UBViewController  {
            controll.tabBarItem.badgeValue = isShow ? "" : nil
            
//            if delegate.navigationController.currentController is UBCProfileController {
//                delegate.navigationController.currentController .updateInfo()
//            }
        }
    }
}
