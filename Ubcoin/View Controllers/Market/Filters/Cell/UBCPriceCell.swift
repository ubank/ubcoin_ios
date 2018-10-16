//
//  UBCPriceCell.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/15/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

@objc class UBCPriceCell: UBDefaultTableViewCell {

    static let className = NSStringFromClass(UBCPriceCell.self)
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.font = UBCFont.title
        textField.textColor = UBCColor.main
        
        return textField
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        leftStackView.removeAllSubviews()
        
        leftStackView.addArrangedSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var rowData: UBTableViewRowData? {
        didSet {
            textField.placeholder = rowData?.title
        }
    }
}

extension UBCPriceCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newString = text.replacingCharacters(in: range, with: string)
            textField.text = newString
            
            
        }
        
        return false
    }
}
