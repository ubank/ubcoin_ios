//
//  UBCFilterParam.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterParam: NSObject {

    private(set) var name: String
    private(set) var title: String
    private(set) var value: String
    var isSelected = false
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let title = dictionary["title"] as? String,
            let value = dictionary["value"] as? String else { return nil }
        
        self.name = name
        self.title = title
        self.value = value
    }
    
    init?(category: UBCCategoryDM?) {
        guard let category = category,
            let title = category.name,
            let value = category.id else { return nil }
        
        self.name = "category"
        self.title = title
        self.value = value
    }
}
