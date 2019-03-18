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
    static let kDealBuyItem = "kSaveDealItemEventBuyNotification"
    static let kDealSoldItem = "kSaveDealItemEventSoldNotification"
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
    
    @objc class var needShowDealItemToBuyBadge: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UBCNotificationConst.kDealBuyItem)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UBCNotificationConst.kDealBuyItem)
            UserDefaults.standard.synchronize()
            
            badgeForDealsController(UBCNotificationDM.profileStatusBadge())
        }
    }
    
    @objc class var needShowDealItemToSoldBadge: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UBCNotificationConst.kDealSoldItem)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UBCNotificationConst.kDealSoldItem)
            UserDefaults.standard.synchronize()
            
            badgeForDealsController(UBCNotificationDM.profileStatusBadge())
        }
    }
    
    @objc static func profileStatusBadge() -> Bool {
        
        if needShowDealItemToBuyBadge {
            return true
        }
        
        if needShowDealItemToSoldBadge {
            return true
        }
        
        return false
    }
    
    @objc static func checkStateDidBecomeActive() {
        
        if UBCNotificationDM.needShowChatBadge {
            UBCNotificationDM.needShowChatBadge = true
        }
        
        if UBCNotificationDM.profileStatusBadge() {
           UBCNotificationDM.needShowDealItemToBuyBadge = true
        }
    }
    
    private class func badgeForMessagesListController(_ isShow: Bool) {
        if let delegate = UIApplication.shared.delegate as? UBCAppDelegate,
        let tab = delegate.navigationController.viewControllers.first as? UITabBarController,
            let controll = tab.viewControllers?.filter({ $0 is UBCMessagesListController }).first as? UBViewController  {
            controll.tabBarItem.badgeValue = isShow ? "" : nil
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
