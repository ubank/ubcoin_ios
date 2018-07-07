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
    
    init(type: UBCSellCellType) {
        self.type = type
        self.height = type == .photo ? 95 : 65
        
        if type == .photo {
            self.className = UBCSPhotoTableViewCell.className
        } else if type == .category || type == .location {
            self.className = UBCSSelectionTableViewCell.className
        } else {
            self.className = UBCSTextFieldTableViewCell.className
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
}

protocol UBCSellCellProtocol {
    func setContent(content: UBCSellCellDM)
}
