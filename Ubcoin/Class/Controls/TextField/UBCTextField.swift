//
//  UBCTextField.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 30.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import UnderLineTextField

class UBCTextField: UnderLineTextField {
    
    private var firstInit = true

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.firstInit {
            self.firstInit = false
            
            self.inactivePlaceholderTextColor = UBColor.descColor
            self.inactiveLineColor = UIColor.init(hexString: "c3d0d4")
            self.activeLineColor = UBColor.titleColor;
            self.font = UIFont.systemFont(ofSize: 18)
            self.textColor = UBColor.titleColor;
        }
    }
}
