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
            return filters.filter { $0.name == UBCFilterType.dateSort.rawValue ||
                $0.name == UBCFilterType.priceSort.rawValue ||
                $0.name == UBCFilterType.distanceSort.rawValue }.first
        } set {
            filters.removeAll(where: { $0.name == UBCFilterType.dateSort.rawValue ||
                $0.name == UBCFilterType.priceSort.rawValue ||
                $0.name == UBCFilterType.distanceSort.rawValue
            })
            if let sort = newValue {
                filters.append(sort)
            }
        }
    }
    
    @objc var priceParam: UBCFilterParam? {
        get {
            return param(type: UBCFilterType.price)
        } set {
            filters.removeAll(where: { $0.name == UBCFilterType.price.rawValue })
            
            if let param = newValue {
                filters.append(param)
            }
        }
    }
    
    @objc var distanceParam: UBCFilterParam? {
        get {
            return param(type: UBCFilterType.distance)
        } set {
            filters.removeAll(where: { $0.name == UBCFilterType.distance.rawValue })
            
            if let param = newValue {
                filters.append(param)
            }
        }
    }
    
    @objc var conditionParam: UBCFilterParam? {
        get {
            return param(type: UBCFilterType.condition)
        } set {
            filters.removeAll(where: { $0.name == UBCFilterType.condition.rawValue })
            
            if let param = newValue {
                filters.append(param)
            }
        }
    }

    @objc var categoryFilters: [UBCFilterParam] {
        return filters.filter { $0.name == UBCFilterType.category.rawValue}
    }

    // MARK: -
    
    private func param(type: UBCFilterType) -> UBCFilterParam {
        let param = filters.filter { $0.name == type.rawValue }.first ?? UBCFilterParam(type: type, value: "")
        filters.removeAll(where: { $0.name == type.rawValue })
        filters.append(param)
        return param
    }
    
    // MARK: -
    
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
            if !filter.value.isEmpty {
                result += "&\(filter.name)=\(filter.value)"
            }
        }
        
        return result
    }
    
    // MARK: -
    
    private(set) lazy var sections: [UBTableViewSectionData] = {
        let filtersSection = UBTableViewSectionData()
        filtersSection.headerTitle = "str_common".localizedString()
        filtersSection.rows = filtersSectionData()
        
        let sortSection = UBTableViewSectionData()
        sortSection.headerTitle = "str_sort_by".localizedString()
        sortSection.rows = sortSectionData()
        
        return [filtersSection, sortSection]
    }()
    
    func filtersSectionData() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        let categories = UBTableViewRowData()
        categories.accessoryType = .disclosureIndicator
        categories.title = UBCFilterType.category.title
        categories.name = UBCFilterType.category.rawValue
        rows.append(categories)
        
        let price = UBTableViewRowData()
        price.title = UBCFilterType.price.title
        price.rightTitle = "UBC"
        price.name = UBCFilterType.price.rawValue
        price.className = UBCPriceCell.className
        price.data = priceParam
        rows.append(price)
        
        let distance = UBTableViewRowData()
        distance.desc = UBCFilterType.distance.title
        distance.name = UBCFilterType.distance.rawValue
        distance.className = UBCFilterValueSelectionCell.className
        distance.height = 100;
        distance.data = distanceParam
        rows.append(distance)
        
        let condition = UBTableViewRowData()
        condition.desc = UBCFilterType.condition.title
        condition.name = UBCFilterType.condition.rawValue
        condition.className = UBCFilterValueSelectionCell.className
        condition.height = 100;
        condition.data = conditionParam
        rows.append(condition)
        
        return rows
    }
    
    func sortSectionData() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        let dateSort = UBTableViewRowData()
        dateSort.title = UBCFilterType.dateSort.title
        dateSort.name = UBCFilterType.dateSort.rawValue
        rows.append(dateSort)
        
        let priceSort = UBTableViewRowData()
        priceSort.title = UBCFilterType.priceSort.title
        priceSort.name = UBCFilterType.priceSort.rawValue
        rows.append(priceSort)
        
        let distanceSort = UBTableViewRowData()
        distanceSort.title = UBCFilterType.distanceSort.title
        distanceSort.name = UBCFilterType.distanceSort.rawValue
        rows.append(distanceSort)
        
        
        return rows
    }
    
    // MARK: -
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = UBCFilterDM()
        copy.filters = filters
        
        return copy
    }
}
