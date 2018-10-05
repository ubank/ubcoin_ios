//
//  UBCFilterCollectionViewCell.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterCollectionViewCell: UICollectionViewCell {

    static let className = String(describing: UBCFilterCollectionViewCell.self)
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.cornerRadius = 10
        self.backgroundColor = UBColor.backgroundColor
        
        self.title.textColor = UBColor.titleColor
        self.title.font = UBFont.titleFont
    }
}
