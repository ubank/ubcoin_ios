//
//  UBCFilterParam.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterParam: NSObject {
    
    static let ascSort = "asc"
    static let descSort = "desc"
    
    private(set) var name: String
    var title: String
    var value: String
    var values: [UBTableViewRowData] {
        switch name {
        case UBCFilterType.distance.rawValue:
            return distanceValues()
        default:
            return []
        }
    }
    
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
        
        self.name = UBCFilterType.category.rawValue
        self.title = title
        self.value = value
    }
    
    init(type: UBCFilterType, value: String) {
        self.name = type.rawValue
        self.title = type.title
        self.value = value
    }
    
    init?(rowData: UBTableViewRowData, value: String) {
        guard let name = rowData.name,
            let title = rowData.title else { return nil }
        
        self.name = name
        self.title = title
        self.value = value
    }
    
    func distanceValues() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        var row = UBTableViewRowData()
        row.title = "1 km"
        row.name = "1"
        rows.append(row)
        
        row = UBTableViewRowData()
        row.title = "5 km"
        row.name = "5"
        rows.append(row)
        
        row = UBTableViewRowData()
        row.title = "10 km"
        row.name = "10"
        rows.append(row)
        
        row = UBTableViewRowData()
        row.title = "100 km"
        row.name = "100"
        rows.append(row)
        
        for row in rows {
            row.isSelected = row.name == self.value
        }
        
        return rows
    }
}

enum UBCFilterType: String {
    case category = "category"
    case price = "maxPrice"
    case distance = "maxDistance"

    case dateSort = "sortByDate"
    case priceSort = "sortByPrice"
    case distanceSort = "sortByDistance"
    
    var title: String {
        switch self {
        case .category:
            return "str_categories".localizedString()
        case .price:
            return "str_max_price".localizedString()
        case .distance:
            return "str_max_distance".localizedString()
        case .dateSort:
            return "str_placement_date".localizedString()
        case .priceSort:
            return "str_item_price".localizedString()
        case .distanceSort:
            return "str_distance_to_seller".localizedString()
        }
    }
}
