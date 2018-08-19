//
//  HUBShared.swift
//  Halva
//
//  Created by Aidar on 05/07/2018.
//  Copyright © 2018 uBank. All rights reserved.
//

import UIKit

class UBCFont {
    static let title = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let desc = UIFont.systemFont(ofSize: 12, weight: .regular)
}

@objc
class UBCColor: NSObject {
    static let main = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 34 / 255.0, alpha: 1)
    static let info = UIColor(red: 64 / 255.0, green: 61 / 255.0, blue: 69 / 255.0, alpha: 0.6)
    static let shadowColor = UIColor.black
    
    @objc static let green = UIColor(red: 50 / 255.0, green: 187 / 255.0, blue: 143 / 255.0, alpha: 1)
    @objc static let tabBar = UIColor(red: 91 / 255.0, green: 103 / 255.0, blue: 109 / 255.0, alpha: 1)
}

@objc
class UBCConstant: NSObject {
    @objc static let actionButtonHeight: CGFloat = 59
    @objc static let inset: CGFloat = 15
    @objc static let cellHeight: CGFloat = 65
    @objc static let defaultCornerRadius: CGFloat = 15
    @objc static let cornerRadius: CGFloat = 10
    @objc static let collectionInset: CGFloat = 15
    
    static let headerHeight: CGFloat = 40
    
    static let shadowOffset = CGSize(width: 0, height: 1)
    static let shadowOpacity: Float = 0.15
    static let shadowRadius: CGFloat = 2
}
