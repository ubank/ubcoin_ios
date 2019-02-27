//
//  UBCDealStatusDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 18/02/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objcMembers
class UBCDealStatusDM: NSObject {
    
    var selected: Bool
    var title: String
    var longTitle: String {
        return title + " " + (desc ?? "")
    }
    
    var desc: String?
    var longDesc: String?
    
    @objc
    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
        let selected = dictionary["selected"] as? Bool else { return nil }
        
        self.title = title
        self.selected = selected
        self.desc = dictionary["description"] as? String
        self.longDesc = dictionary["longDescription"] as? String
    }
}
