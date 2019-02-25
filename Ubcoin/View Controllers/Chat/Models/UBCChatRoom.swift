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
    
    init?(dictionary: [String: Any]) {
        
        guard let user = dictionary["user"] as? [String: Any],
            let item = dictionary["item"] as? [String: Any] else { return nil }
        
        self.user = UBCSellerDM(dictionary: user)
        self.item = UBCGoodDM(dictionary: item)
    }
    
    func rowData() -> UBTableViewRowData {
        
        let data = UBTableViewRowData()
        data.accessoryType = .disclosureIndicator
        data.data = self
        data.title = user.name
        data.desc = item.title
        data.iconURL = item.imageURL
        data.icon = UIImage(named: "item_default_image")
        data.height = 95
        
        return data
    }
}
