//
//  UBCFilterParam.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterParam: NSObject {

    static let categoryType = "category"
    static let priceType = "maxPrice"
    static let distanceType = "maxDistance"
    
    static let dateSortType = "sortByDate"
    static let priceSortType = "sortByPrice"
    static let distanceSortType = "sortByDistance"
    
    static let ascSort = "asc"
    static let descSort = "desc"
    
    private(set) var name: String
    private(set) var title: String
    var value: String
    
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
        
        self.name = UBCFilterParam.categoryType
        self.title = title
        self.value = value
    }
    
    init?(rowData: UBTableViewRowData) {
        guard let name = rowData.name,
            let title = rowData.title else { return nil }
        
        self.name = name
        self.title = title
        self.value = UBCFilterParam.ascSort
    }
}
