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
}

@objc
class UBCConstant: NSObject {
    @objc static let actionButtonHeight: CGFloat = 59
    @objc static let inset: CGFloat = 15
    @objc static let cellHeight: CGFloat = 65
    @objc static let cornerRadius: CGFloat = 10
    @objc static let headerHeight: CGFloat = 40
}
