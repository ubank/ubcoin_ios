//
//  UBCFilterDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/5/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterDM: NSObject {

    var filters = [UBCFilterParam]()
    
    @objc var categoryFilters: [UBCFilterParam] {
        return filters.filter { $0.name == "category"}
    }
    
    @objc func updateCategoryFilters(selectedCategoryFilters: [UBCFilterParam]) {
        let currentCategoryFilters = categoryFilters
        for filter in currentCategoryFilters {
            if let index = filters.index(of: filter) {
                filters.remove(at: index)
            }
        }
        
        filters.append(contentsOf: selectedCategoryFilters)
    }
    
    @objc func filterValues() -> String {
        var result = ""
        for filter in filters {
            result += "&\(filter.name)=\(filter.value)"
        }
        return result
    }
}
