//
//  UBCFilterDM.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/5/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit


class UBCFilterDM: NSObject, NSCopying {

    @objc var filters = [UBCFilterParam]()
    @objc var sortParam: UBCFilterParam? {
        get {
            return filters.filter { $0.name == UBCFilterParam.dateSortType ||
                $0.name == UBCFilterParam.priceSortType ||
                $0.name == UBCFilterParam.distanceSortType }.first
        } set {
            filters.removeAll(where: { $0.name == UBCFilterParam.dateSortType ||
                $0.name == UBCFilterParam.priceSortType ||
                $0.name == UBCFilterParam.distanceSortType
            })
            if let sort = newValue {
                filters.append(sort)
            }
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = UBCFilterDM()
        copy.filters = filters
        
        return copy
    }
    
    @objc var categoryFilters: [UBCFilterParam] {
        return filters.filter { $0.name == UBCFilterParam.categoryType}
    }
    
    private(set) lazy var sections: [UBTableViewSectionData] = {
        let filtersSection = UBTableViewSectionData()
        filtersSection.headerTitle = "str_common".localizedString()
        filtersSection.rows = filtersSectionData()
        
        let sortSection = UBTableViewSectionData()
        sortSection.headerTitle = "str_sort_by".localizedString()
        sortSection.rows = sortSectionData()
        
        return [filtersSection, sortSection]
    }()
    
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
    
    func filtersSectionData() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        let row = UBTableViewRowData()
        row.accessoryType = .disclosureIndicator
        row.title = "str_all_categories".localizedString()
        row.name = UBCFilterParam.categoryType
        row.className = "UBDefaultTableViewCell"
        rows.append(row)
        
        return rows
    }
    
    func sortSectionData() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        let dateSort = UBTableViewRowData()
        dateSort.title = "str_placement_date".localizedString()
        dateSort.name = UBCFilterParam.dateSortType
        dateSort.className = "UBDefaultTableViewCell"
        rows.append(dateSort)
        
        let priceSort = UBTableViewRowData()
        priceSort.title = "str_item_price".localizedString()
        priceSort.name = UBCFilterParam.priceSortType
        priceSort.className = "UBDefaultTableViewCell"
        rows.append(priceSort)
        
        let distanceSort = UBTableViewRowData()
        distanceSort.title = "str_distance_to_seller".localizedString()
        distanceSort.name = UBCFilterParam.distanceSortType
        distanceSort.className = "UBDefaultTableViewCell"
        rows.append(distanceSort)
        
        
        return rows
    }
}
