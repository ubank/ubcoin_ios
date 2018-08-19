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

    class func sellActions() -> [UBTableViewSectionData] {
        var sections = [UBTableViewSectionData]()
        
        let photoSection = UBTableViewSectionData()
        photoSection.headerHeight = SEPARATOR_HEIGHT
        photoSection.headerTitle = " "
        let photos = UBCSellCellDM(type: .photo)
        photoSection.rows = [photos]
        sections.append(photoSection)
        
        let aboutSection = UBTableViewSectionData()
        aboutSection.headerHeight = UBCConstant.headerHeight
        aboutSection.headerTitle = "str_sell_about".localizedString()
        let title = UBCSellCellDM(type: .title)
        let category = UBCSellCellDM(type: .category)
        let price = UBCSellCellDM(type: .price)
        aboutSection.rows = [title, category, price]
        sections.append(aboutSection)
        
        let descSection = UBTableViewSectionData()
        descSection.headerHeight = UBCConstant.headerHeight
        descSection.headerTitle = "str_sell_desc".localizedString()
        let desc = UBCSellCellDM(type: .desc)
        descSection.rows = [desc]
        sections.append(descSection)

        let locationSection = UBTableViewSectionData()
        locationSection.headerHeight = UBCConstant.headerHeight
        locationSection.headerTitle = "str_sell_location".localizedString()
        let location = UBCSellCellDM(type: .location)
        locationSection.rows = [location]
        sections.append(locationSection)
        
        return sections
    }
    
    func setup(categories: [Any]?) {
        guard let categoriesArray = categories as? [UBCCategoryDM] else { return }
        
        for section in sections {
            for i in 0..<section.rows.count {
                if var row = section.rows[i] as? UBCSellCellDM, row.type == .category {
                    row.selectContent = categoriesArray
                    section.rows[i] = row
                }
            }
        }
    }
    
    func updateRow(_ row: UBCSellCellDM) {
        for section in sections {
            for i in 0..<section.rows.count {
                if let oldRow = section.rows[i] as? UBCSellCellDM, oldRow.type == row.type {
                    section.rows[i] = row
                    
                    guard row.type == .location, var lastRow = section.rows.last as? UBCSellCellDM else { return }
                
                    if lastRow.type != .locationMap {
                        lastRow = UBCSellCellDM(type: .locationMap)
                        section.rows.append(lastRow)
                    }
                    
                    lastRow.sendData = row.sendData
                    section.rows[section.rows.count-1] = lastRow
                }
            }
        }
    }
    
    func updatePhotoRow(image: UIImage) {
        for section in sections {
            for i in 0..<section.rows.count {
                if var row = section.rows[i] as? UBCSellCellDM, row.type == .photo {
                    if row.data as? [UIImage] == nil {
                        row.data = [UIImage]()
                    }
                    
                    if var data = row.data as? [UIImage] {
                        data.append(image)
                        row.data = data
                    }
                    
                    row.sendData = ["https://my.ubcoin.io/api/images/8988a3ce-108f-4581-93dd-f33e4658b482.jpg"]
                    
                    section.rows[i] = row
                }
            }
        }
    }
    
    func photoRow() -> UBCSellCellDM? {
        for section in sections {
            for i in 0..<section.rows.count {
                if let row = section.rows[i] as? UBCSellCellDM, row.type == .photo {
                    return row
                }
            }
        }
        
        return nil
    }
    
    func isAllParamsNotEmpty() -> Bool {
        for section in sections {
            for row in section.rows {
                if let row = row as? UBCSellCellDM, !row.optional, row.sendData == nil {
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
}

struct UBCSellCellDM {
    var type: UBCSellCellType
    var height: CGFloat
    var className: String
    
    var data: Any?
    var sendData: Any?
    var placeholder: String
    var optional = false
    var keyboardType: UIKeyboardType = .default
    
    var selectContent: [UBCCategoryDM]?
    var fieldInfo: String?
    
    init(type: UBCSellCellType) {
        self.type = type
        self.height = type == .photo || type == .locationMap ? 90 : UBCConstant.cellHeight
        
        self.className = type.className
        self.placeholder = type.placeholder
        
        if type == .locationMap {
            self.optional = true
        }
        
        if type == .price {
            self.keyboardType = .decimalPad
        }
        
        if type == .category {
            self.selectContent = []
        }
        
        if type == .price {
            self.fieldInfo = "$"
        }
    }
}

enum UBCSellCellType {
    case photo
    case title
    case category
    case price
    case desc
    case location
    case locationMap
    
    var className: String {
        get {
            if self == .photo {
                return UBCSPhotoTableViewCell.className
            } else if self == .category || self == .location {
                return UBCSSelectionTableViewCell.className
            } else if self == .price || self == .title {
                return UBCSTextFieldTableViewCell.className
            } else if self == .locationMap {
                return UBCSMapTableViewCell.className
            } else {
                return UBCSTextViewTableViewCell.className
            }
        }
    }
    
    var placeholder: String {
        get {
            if self == .category {
                return "str_sell_placeholder_category".localizedString()
            } else if self == .location {
                return "str_sell_placeholder_location".localizedString()
            } else if self == .price {
                return "str_sell_placeholder_price".localizedString()
            } else if self == .title {
                return "str_sell_placeholder_title".localizedString()
            } else {
                return ""
            }
        }
    }
    
    var sendType: String {
        get {
            if self == .photo {
                return "images"
            } else if self == .title {
                return "title"
            } else if self == .category {
                return "categoryId"
            } else if self == .price {
                return "price"
            } else if self == .desc {
                return "description"
            } else {
                return "location"
            }
        }
    }
}

protocol UBCSellCellProtocol {
    func setContent(content: UBCSellCellDM)
}

protocol UBCSTextCellDelegate {
    func updateTableView()
    func updatedRow(_ row: UBCSellCellDM)
}
