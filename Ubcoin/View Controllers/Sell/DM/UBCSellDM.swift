//
//  UBCSellDM.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSellDM: NSObject {

    private static let headerHeight: CGFloat = 40

    class func sellActions() -> [UBTableViewSectionData] {
        
        var sections = [UBTableViewSectionData]()
        
        let photoSection = UBTableViewSectionData()
        photoSection.headerHeight = SEPARATOR_HEIGHT
        photoSection.headerTitle = " "
        var photos = UBCSellCellDM(type: .photo)
        photos.height = 95
        photoSection.rows = [photos]
        sections.append(photoSection)
        
        let aboutSection = UBTableViewSectionData()
        aboutSection.headerHeight = headerHeight
        aboutSection.headerTitle = "About"
        let title = UBCSellCellDM(type: .title)
        let category = UBCSellCellDM(type: .category)
        let price = UBCSellCellDM(type: .price)
        aboutSection.rows = [title, category, price]
        sections.append(aboutSection)
        
        let descSection = UBTableViewSectionData()
        descSection.headerHeight = headerHeight
        descSection.headerTitle = "Description"
        let desc = UBCSellCellDM(type: .desc)
        descSection.rows = [desc]
        sections.append(descSection)

        let locationSection = UBTableViewSectionData()
        locationSection.headerHeight = headerHeight
        locationSection.headerTitle = "Location"
        let location = UBCSellCellDM(type: .location)
        locationSection.rows = [location]
        sections.append(locationSection)
        
        return sections
    }
}

struct UBCSellCellDM {
    var type: UBCSellCellType
    var height: CGFloat
    var className: String
    
    var data: Any?
    var placeholder: String
    var selectContent: [String]?
    
    init(type: UBCSellCellType) {
        self.type = type
        self.height = type == .photo ? 95 : 65
        
        self.className = type.className
        self.placeholder = type.placeholder
        
        if type == .category {
            self.selectContent = ["Accessories", "Clothes", "Transport", "Home", "Animals", "Gifts"]
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
    
    var className: String {
        get {
            if self == .photo {
                return UBCSPhotoTableViewCell.className
            } else if self == .category || self == .location {
                return UBCSSelectionTableViewCell.className
            } else {
                return UBCSTextFieldTableViewCell.className
            }
        }
    }
    
    var placeholder: String {
        get {
            if self == .category {
                return "Select category"
            } else if self == .location {
                return "Select location"
            } else {
                return ""
            }
        }
    }
}

protocol UBCSellCellProtocol {
    func setContent(content: UBCSellCellDM)
}
