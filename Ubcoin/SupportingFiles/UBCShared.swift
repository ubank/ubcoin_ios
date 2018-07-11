//
//  HUBShared.swift
//  Halva
//
//  Created by Aidar on 05/07/2018.
//  Copyright © 2018 uBank. All rights reserved.
//

import UIKit

@objc
class UBCFont: NSObject {
}

@objc
class UBCColor: NSObject {
    @objc static let green = UIColor.init(red: 50 / 255.0, green: 187 / 255.0, blue: 143 / 255.0, alpha: 1)
    @objc static let tabBar = UIColor.init(red: 91 / 255.0, green: 103 / 255.0, blue: 109 / 255.0, alpha: 1)
    @objc static let shadowColor = UIColor.black
}

@objc
class UBCConstant: NSObject {
    @objc static let actionButtonHeight: CGFloat = 59
    @objc static let inset: CGFloat = 15
    @objc static let cellHeight: CGFloat = 65
    @objc static let defaultCornerRadius: CGFloat = 15
    @objc static let cornerRadius: CGFloat = 10
    @objc static let headerHeight: CGFloat = 40
    @objc static let collectionInset: CGFloat = 15
    
    @objc static let shadowOffset = CGSize(width: 0, height: 1)
    @objc static let shadowOpacity: Float = 0.15
    @objc static let shadowRadius: CGFloat = 5
}

extension UIView {
    
    func defaultShadow() {
        self.layer.cornerRadius = UBCConstant.cornerRadius
        self.layer.shadowColor = UBCColor.shadowColor.cgColor
        self.layer.shadowOpacity = UBCConstant.shadowOpacity
        self.layer.shadowRadius = UBCConstant.shadowRadius
        self.layer.shadowOffset = UBCConstant.shadowOffset
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
    }
}
