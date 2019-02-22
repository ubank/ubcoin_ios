//
//  UBCChatRoom.swift
//  Ubcoin
//
//  Created by vkrotin on 22.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc class UBCChatRoom: NSObject {
    
    var seller:UBCSellerDM?
    var name = ""
    var imageUrl:String?
    var id:String?
    
    
    @objc init(item:[String:Any]) {
        
        if let itemUser = item["user"] as? [String:Any] {
            seller = UBCSellerDM(dictionary: itemUser)
        }
        
        if let product = item["item"] as? [String:Any], let images = product["images"] as? [String] {
            name = product["title"] as? String ?? ""
            id = product["id"] as? String ?? ""
            imageUrl = images.first
        }
    
    }
    
    @objc func rowData() -> UBTableViewRowData {
        let data = UBTableViewRowData()
        data.accessoryType = .disclosureIndicator
        data.data = self
        data.title = seller?.name
        data.desc = name
        data.iconURL = imageUrl
        data.icon = UIImage(named: "item_default_image")
        data.height = 95
        
        return data
    }

    

}
