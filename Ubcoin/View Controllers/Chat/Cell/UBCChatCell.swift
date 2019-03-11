//
//  UBCChatCell.swift
//  Ubcoin
//
//  Created by vkrotin on 11.03.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import MiniLayout

class UBCChatCell: UBDefaultTableViewCell {
    
    let lastMessageLabel: HUBLabel = HUBLabel(style: HUBLabelStyleDefaultDescription)
    let dateLabel: HUBLabel = HUBLabel(style: HUBLabelStyleDefaultDescription)
    let iconArrow = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.setBottomConstraintToSubview(badgeView, withValue: -10, relatedBy: .equal)
        
        lastMessageLabel.textColor = UBColor.titleColor
        dateLabel.textColor = UBColor.titleColor
        dateLabel.textAlignment = .right

        icon.cornerRadius = 10
        iconWidth = 75
        iconHeight = 75
        icon.contentMode = .scaleAspectFill
        iconContentModeSetted = true
        
        iconArrow.image = UIImage(named: "arrow")
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, iconArrow])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        
        let stackH = UIStackView(arrangedSubviews: [stackView, UIView()])
        stackH.axis = .vertical
        stackH.distribution = .fillEqually
        stackH.alignment = .fill
        stackH.spacing = 24
        
        horizontalStackView.addArrangedSubview(stackH)
        leftStackView.addArrangedSubview(lastMessageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
