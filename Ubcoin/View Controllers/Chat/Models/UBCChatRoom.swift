//
//  UBCChatRoom.swift
//  Ubcoin
//
//  Created by vkrotin on 22.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objcMembers class UBCChatRoom: NSObject {
    
    var user: UBCSellerDM
    var item: UBCGoodDM
    
    let lastMessage: UBCChatRoomLastMessage
    var unreadCount: Int
    
    init?(dictionary: [String: Any]) {
        
        guard let user = dictionary["user"] as? [String: Any],
            let item = dictionary["item"] as? [String: Any] else { return nil }
        
        self.user = UBCSellerDM(dictionary: user)
        self.item = UBCGoodDM(dictionary: item)
        self.unreadCount = dictionary["unreadCount"] as? Int ?? 0
        self.lastMessage = UBCChatRoomLastMessage(dictionary["lastMessage"] as? [String : Any])
    }
    
    func rowData() -> UBTableViewRowData {
        
        let data = UBTableViewRowData()
        data.accessoryType = .none
        data.data = self
        data.className = NSStringFromClass(UBCChatCell.self)
        data.title = user.name
        data.desc = item.title
        data.iconURL = item.imageURL
        data.icon = UIImage(named: "item_default_image")
        data.height = 95
        
        return data
    }
    
}

extension Date {
    
    func dateStringFormatMMMD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UBLocal.shared.language == "ru" ? "d MMM" : "MMM d"
        
        return dateFormatter.string(from: self)
    }
    
}

@objcMembers class UBCChatRoomLastMessage: NSObject {
    
    let id: String
    let date: Date
    let userName: String
    var message: String
    
    init(_ dictionary: [String: Any]?) {
        
        guard let dictionary = dictionary else {
            id = ""
            date = Date()
            userName = ""
            message = ""
            super.init()
            return
        }
        
        self.id = dictionary["id"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.message = UBCChatRoomLastMessage.message(from: dictionary["msg"] as? [String : Any])
        self.date = NSDate(fromISO8601String: dictionary["date"] as? String ?? "") as Date
        super.init()
    }
    
    
    static func message(from msg:[String: Any]?) -> String {
        guard let msg = msg,
              let type = msg["type"] as? String,
              let content = msg["content"] as? String else {
            return ""
        }
        
        return type == "message" ? content : "Message with image"
    }
}
