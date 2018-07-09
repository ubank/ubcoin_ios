//
//  UBCSSelectionTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSSelectionTableViewCell: UBTableViewCell {

    static let className = String(describing: UBCSSelectionTableViewCell.self)
    
    private var title: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .disclosureIndicator
        self.tintColor = UBColor.titleColor.withAlphaComponent(0.5)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.title = UILabel()
        self.title.font = UBFont.titleFont
        self.title.numberOfLines = 2
        self.contentView.addSubview(self.title)
        self.contentView.setLeadingConstraintToSubview(self.title, withValue: UBCConstant.inset)
        self.contentView.setTrailingConstraintToSubview(self.title, withValue: -UBCConstant.inset)
        self.contentView.setCenterYConstraintToSubview(self.title)
    }
}


extension UBCSSelectionTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        if let titleText = content.data as? String {
            self.title.text = titleText
            self.title.textColor = UBColor.titleColor
        } else {
            self.title.text = content.placeholder
            self.title.textColor = UBColor.titleColor.withAlphaComponent(0.5)
        }
    }
}
