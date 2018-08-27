//
//  UBCSTextFieldTableCell.swift
//  Ubcoin
//
//  Created by Aidar on 09/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSTextFieldTableViewCell: UBTableViewCell {
    
    static let className = String(describing: UBCSTextFieldTableViewCell.self)
    
    var delegate: UBCSTextCellDelegate?
    
    private var content: UBCSellCellDM?
    
    private var stackView: UIStackView!
    private var textField: UITextField!
    private var info: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.textField = UITextField()
        self.textField.delegate = self
        self.textField.font = UBCFont.title
        self.textField.textColor = UBCColor.main

        self.info = UILabel()
        self.info.font = UBCFont.title
        self.info.numberOfLines = 1
        self.info.textColor = UBCColor.main
        
        self.stackView = UIStackView(arrangedSubviews: [self.textField, self.info])
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.spacing = 5
        self.contentView.addSubview(self.stackView)
        self.contentView.setAllConstraintToSubview(self.stackView, with: UIEdgeInsets(top: 15, left: UBCConstant.inset, bottom: -15, right: -UBCConstant.inset))
    }
}


extension UBCSTextFieldTableViewCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newString = text.replacingCharacters(in: range, with: string)
            textField.text = newString
            
            if let delegate = self.delegate, var content = self.content {
                content.data = textField.text
                content.sendData = textField.text
                delegate.updatedRow(content)
            }
        }
        
        return false
    }
}


extension UBCSTextFieldTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        self.content = content
        
        self.textField.attributedPlaceholder = NSAttributedString(string: content.placeholder, attributes: [.font: UBCFont.title, .foregroundColor: UBCColor.info])
        self.textField.keyboardType = content.keyboardType
        self.textField.text = content.data as? String
        
        if let info = content.fieldInfo {
            self.info.text = info
            self.info.isHidden = false
            let width = self.info.sizeThatFits(CGSize(width: self.width, height: self.info.font.lineHeight)).width
            self.info.setWidthConstraintWithValue(width)
        } else {
            self.info.isHidden = true
        }
    }
}
