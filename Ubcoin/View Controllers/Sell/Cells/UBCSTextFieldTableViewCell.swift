//
//  UBCSTextFieldTableCell.swift
//  Ubcoin
//
//  Created by Aidar on 09/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

protocol UBCSTextFieldTableViewCellDelegate {
    func updateTableView()
}


class UBCSTextFieldTableViewCell: UBTableViewCell {
    
    static let className = String(describing: UBCSTextFieldTableViewCell.self)
    
    var delegate: UBCSTextFieldTableViewCellDelegate?
    
    private var stackView: UIStackView!
    private var title: UILabel!
    private var textField: UITextField!
    private var info: UILabel!
    private var desc: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.title = UILabel()
        self.title.font = UBFont.titleFont
        self.title.numberOfLines = 1
        self.title.textColor = UBColor.titleColor.withAlphaComponent(0.5)
        
        self.textField = UITextField()
        self.textField.delegate = self
        self.textField.font = UBFont.titleFont
        self.textField.textColor = UBColor.titleColor
        self.textField.textAlignment = .right
        
        self.info = UILabel()
        self.info.font = UBFont.titleFont
        self.info.numberOfLines = 1
        self.info.textColor = UBColor.titleColor
        
        self.stackView = UIStackView(arrangedSubviews: [self.title, self.textField, self.info])
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.spacing = 5
        self.contentView.addSubview(self.stackView)
        self.contentView.setAllConstraintToSubview(self.stackView, with: UIEdgeInsets(top: 15, left: UBCConstant.inset, bottom: -15, right: -UBCConstant.inset))
        
        self.desc = UILabel()
        self.desc.font = UBFont.descFont
        self.desc.numberOfLines = 1
        self.desc.textColor = UBColor.descColor
        self.contentView.addSubview(self.desc)
        self.contentView.setTrailingConstraintToSubview(self.desc, withValue: -UBCConstant.inset)
        self.contentView.setBottomConstraintToSubview(self.desc, withValue: -5)
    }
}


extension UBCSTextFieldTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newString = text.replacingCharacters(in: range, with: string)
            
            if !self.desc.isHidden, let value = Double(newString), let valueStr = NSNumber(value: value * 1.2).priceString {
                self.desc.text = "\(valueStr) UBC"
            } else {
                self.desc.text = ""
            }
            
            textField.text = newString
        }
        
        return false
    }
}


extension UBCSTextFieldTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        self.title.text = content.placeholder
        
        let width = self.title.sizeThatFits(CGSize(width: self.width, height: self.title.font.lineHeight)).width
        self.title.setWidthConstraintWithValue(width + 5)

        if let text = content.data as? String {
            self.textField.text = text
        }
        
        if let info = content.fieldInfo {
            self.info.text = info
            self.info.isHidden = false
            let width = self.info.sizeThatFits(CGSize(width: self.width, height: self.info.font.lineHeight)).width
            self.info.setWidthConstraintWithValue(width)
            self.desc.isHidden = false
        } else {
            self.info.isHidden = true
            self.desc.isHidden = true
        }
    }
}
