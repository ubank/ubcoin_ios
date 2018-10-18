//
//  UBCFilterTitleCollectionViewCell.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/18/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFilterTitleCollectionViewCell: UICollectionViewCell {

    static let className = String(describing: UBCFilterTitleCollectionViewCell.self)
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cornerRadius = 10
        self.backgroundColor = UIColor(hexString: "F1F1F1")
        
        self.title.textColor = UBColor.titleColor
        self.title.font = UBFont.titleFont
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UBCColor.green : UIColor(hexString: "F1F1F1")
            self.title.textColor = isSelected ? UIColor.white : UBColor.titleColor
        }
    }
}
