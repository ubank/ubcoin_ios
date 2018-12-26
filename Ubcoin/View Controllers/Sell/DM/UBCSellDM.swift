//
//  UBCSellDM.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSellDM: NSObject {
    
    var sections = UBCSellDM.sellActions()
    var item: UBCGoodDM?
    
    convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
        self.sections = UBCSellDM.sellActions(good: item)
    }
    
    class func sellActions(good: UBCGoodDM? = nil, categoryID: String? = nil) -> [UBTableViewSectionData] {
        var sections = [UBTableViewSectionData]()
        
        let photoSection = UBTableViewSectionData()
        photoSection.headerHeight = SEPARATOR_HEIGHT
        photoSection.headerTitle = " "
        
        var photos = UBCSellCellDM(type: .photo)
        photos.data = good?.images ?? []
        
        photoSection.rows = [photos]
        sections.append(photoSection)
        
        let aboutSection = UBTableViewSectionData()
        aboutSection.headerHeight = UBCConstant.headerHeight
        aboutSection.headerTitle = "str_sell_about".localizedString()
        
        var title = UBCSellCellDM(type: .title)
        title.data = good?.title
        title.sendData = good?.title
        
        var category = UBCSellCellDM(type: .category)
        category.data = good?.category?.name
        category.sendData = good?.category?.id
        
        let isDigital = categoryID != nil ? (categoryID == DigitalGoodsID) : good?.isDigital ?? false
        
        if isDigital {
            aboutSection.rows = [title, category]
        } else {
            var condition = UBCSellCellDM(type: .condition)
            condition.data = good?.condition?.capitalized
            condition.sendData = good?.condition
            
            aboutSection.rows = [title, category, condition]
        }
        
        sections.append(aboutSection)
        
        if isDigital {
            let linkSection = UBTableViewSectionData()
            linkSection.headerHeight = UBCConstant.headerHeight
            linkSection.headerTitle = "str_link_to_download_the_file".localizedString()
            linkSection.footerTitle = "str_paste_here_link_to_download_your_file_from_cloud_storage".localizedString()
            
            var link = UBCSellCellDM(type: .link)
            link.data = good?.fileURL
            link.sendData = good?.fileURL
            
            linkSection.rows = [link]
            sections.append(linkSection)
        }
        
        let priceDollarSection = UBTableViewSectionData()
        priceDollarSection.headerHeight = UBCConstant.headerHeight
        priceDollarSection.headerTitle = "str_price_in".localizedString() + " $"
        priceDollarSection.footerTitle = "str_buyer_can_pay_you_in_UBC_or_ETH".localizedString()
        
        var price = UBCSellCellDM(type: .price)
        price.data = good?.priceInCurrency?.stringValue
        price.sendData = good?.priceInCurrency
        
        priceDollarSection.rows = [price]
        sections.append(priceDollarSection)
        
        let priceUBCSection = UBTableViewSectionData()
        priceUBCSection.headerHeight = UBCConstant.headerHeight
        priceUBCSection.headerTitle = "str_price_in".localizedString() + " UBC"
        
        var priceUBC = UBCSellCellDM(type: .priceUBC)
        priceUBC.data = good?.price?.stringValue
        priceUBC.sendData = good?.price
        
        priceUBCSection.rows = [priceUBC]
        sections.append(priceUBCSection)
        
        let priceETHSection = UBTableViewSectionData()
        priceETHSection.headerHeight = UBCConstant.headerHeight
        priceETHSection.headerTitle = "str_price_in".localizedString() + " ETH"
        
        var priceETH = UBCSellCellDM(type: .priceETH)
        priceETH.data = good?.priceInETH?.stringValue
        priceETH.sendData = good?.priceInETH
        
        priceETHSection.rows = [priceETH]
        sections.append(priceETHSection)
        
        let descSection = UBTableViewSectionData()
        descSection.headerHeight = UBCConstant.headerHeight
        descSection.headerTitle = "str_sell_desc".localizedString()
        
        var desc = UBCSellCellDM(type: .desc)
        desc.data = good?.desc
        desc.sendData = good?.desc
        
        descSection.rows = [desc]
        sections.append(descSection)

        if !isDigital {
            let locationSection = UBTableViewSectionData()
            locationSection.headerHeight = UBCConstant.headerHeight
            locationSection.headerTitle = "str_sell_location".localizedString()
            
            var location = UBCSellCellDM(type: .location)
            if let loc = good?.location, let text = good?.locationText {
                location.data = text
                location.sendData = ["text": text, "longPoint": loc.coordinate.longitude, "latPoint": loc.coordinate.latitude]
            }
            
            locationSection.rows = [location]
            sections.append(locationSection)
        }
        return sections
    }
    
    @discardableResult
    func updateRow(_ row: UBCSellCellDM?) -> IndexPath? {
        guard let row = row else { return nil }
        
        for j in 0..<sections.count {
            let section = sections[j]
            for i in 0..<section.rows.count {
                if let oldRow = section.rows[i] as? UBCSellCellDM, oldRow.type == row.type {
                    section.rows[i] = row
                    
                    guard row.type == .location, var lastRow = section.rows.last as? UBCSellCellDM else {
                        return IndexPath(row: i, section: j)
                    }
                
                    if lastRow.type != .locationMap {
                        lastRow = UBCSellCellDM(type: .locationMap)
                        section.rows.append(lastRow)
                    }
                    
                    lastRow.sendData = row.sendData
                    section.rows[section.rows.count-1] = lastRow
                    
                    return IndexPath(row: i, section: j)
                }
            }
        }
        
        return nil
    }
    
    func removePhoto(index: Int) {
        for section in sections {
            for i in 0..<section.rows.count {
                if var row = section.rows[i] as? UBCSellCellDM, row.type == .photo {
                    if var data = row.data as? [Any], index >= 0, index < data.count {
                        data.remove(at: index)
                        row.data = data
                    }
                    
                    section.rows[i] = row
                }
            }
        }
    }
    
    func row(type: UBCSellCellType) -> UBCSellCellDM? {
        for section in sections {
            for i in 0..<section.rows.count {
                if let row = section.rows[i] as? UBCSellCellDM, row.type == type {
                    return row
                }
            }
        }
        
        return nil
    }
    
    func isAllParamsNotEmpty() -> Bool {
        for section in sections {
            for row in section.rows {
                if let row = row as? UBCSellCellDM, !row.optional, row.sendData == nil, ((row.data as? [Any])?.count ?? 0) == 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    func allFilledParams() -> [String: Any] {
        var dict = [String: Any]()
        
        for section in self.sections {
            for row in section.rows {
                if let row = row as? UBCSellCellDM, let data = row.sendData {
                    dict[row.type.sendType] = data
                }
            }
        }
        
        return dict
    }
    
    func reloadParams() {
        let category = self.row(type: .category)
        let images = self.row(type: .photo)
        self.item = UBCGoodDM(dictionary: self.allFilledParams())
        self.sections = UBCSellDM.sellActions(good: item, categoryID: category?.sendData as? String)
        self.updateRow(category)
        self.updateRow(images)
    }
}

struct UBCSellCellDM {
    var type: UBCSellCellType
    var height: CGFloat
    var className: String
    
    var data: Any?
    var sendData: Any?
    var placeholder: String
    var optional = false
    var isEditable = true
    var keyboardType: UIKeyboardType = .default
    var reloadButtonActive = false
    
    init(type: UBCSellCellType) {
        self.type = type
        self.height = type == .photo || type == .locationMap ? 90 : UBCConstant.cellHeight
        
        self.className = type.className
        self.placeholder = type.placeholder
        
        if type == .locationMap {
            self.optional = true
        }
        
        if type == .price || type == .priceUBC || type == .priceETH {
            self.keyboardType = .decimalPad
        }
    }
    
    func imageForIndex(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let array = self.data as? [Any], array.count > index, index >= 0 else {
            completion(nil)
            
            return
        }
        
        let image = array[index]
        
        if let image = image as? UIImage {
            completion(image)
        } else if let imageStr = image as? String {
            SDWebImageManager.shared().loadImage(with: URL(string: imageStr), options: .highPriority, progress: nil) { image, _, _, _, _, _ in
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
}

enum UBCSellCellType {
    case photo
    case title
    case category
    case link
    case condition
    case price
    case priceUBC
    case priceETH
    case desc
    case location
    case locationMap
    
    var className: String {
        get {
            switch self {
            case .photo:
                return UBCSPhotoTableViewCell.className
            case .category, .condition, .location:
                return UBCSSelectionTableViewCell.className
            case .price, .priceUBC, .priceETH, .title, .link:
                return UBCSTextFieldTableViewCell.className
            case .locationMap:
                return UBCSMapTableViewCell.className
            default:
                return UBCSTextViewTableViewCell.className
            }
        }
    }
    
    var placeholder: String {
        get {
            switch self {
            case .category:
                return "str_category".localizedString()
            case .condition:
                return "str_condition".localizedString()
            case .location:
                return "str_sell_placeholder_location".localizedString()
            case .title:
                return "str_sell_placeholder_title".localizedString()
            case .link:
                return "str_link_placeholder".localizedString()
            default:
                return ""
            }
        }
    }
    
    var sendType: String {
        get {
            switch self {
            case .photo:
                return "images"
            case .title:
                return "title"
            case .category:
                return "categoryId"
            case .link:
                return "fileUrl"
            case .condition:
                return "condition"
            case .price:
                return "priceInCurrency"
            case .priceUBC:
                return "price"
            case .priceETH:
                return  "priceETH"
            case .desc:
                return "description"
            default:
                return "location"
            }
        }
    }
    
    var values: [UBTableViewRowData] {
        switch self {
        case .condition:
            return conditionValues()
        default:
            return []
        }
    }
    
    func conditionValues() -> [UBTableViewRowData] {
        var rows = [UBTableViewRowData]()
        
        var row = UBTableViewRowData()
        row.title = "str_new".localizedString()
        row.name = conditionValueNew
        rows.append(row)
        
        row = UBTableViewRowData()
        row.title = "str_used".localizedString()
        row.name = conditionValueUsed
        rows.append(row)
        
        return rows
    }
    
}

protocol UBCSellCellProtocol {
    func setContent(content: UBCSellCellDM)
}

protocol UBCSTextCellDelegate {
    func updateTableView()
    func updatedRow(_ row: UBCSellCellDM)
}
