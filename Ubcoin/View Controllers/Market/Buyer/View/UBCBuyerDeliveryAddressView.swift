//
//  UBCBuyerDeliveryAddressView.swift
//  Ubcoin
//
//  Created by vkrotin on 05.03.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCBuyerDeliveryAddressViewDelegate: class {
    
    func buyerDeliveryAddress(_ address: String)
    
}

class UBCBuyerDeliveryAddressView: UIView {
    
    @IBOutlet weak var delegate: UBCBuyerDeliveryAddressViewDelegate?

    @IBOutlet private weak var deliveryHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var deliveryAddressLabel: HUBLabel!
    @IBOutlet weak var deliveryTextView: UBTextView!
    @IBOutlet private weak var noticeLabel: HUBLabel!
    
    private var placeholderLabel : UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCBuyerDeliveryAddressView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)
        
        deliveryAddressLabel.text = "str_delivery_address".localizedString()
        noticeLabel.text = "str_delivery_notice".localizedString()
        noticeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        deliveryTextView.textColor = UBCColor.green
        deliveryTextView.font = UBCFont.title
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "str_delivery_address_placeholder".localizedString()
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (deliveryTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        deliveryTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (deliveryTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !deliveryTextView.text.isEmpty
    }

}

extension UBCBuyerDeliveryAddressView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        deliveryHeightConstraint.constant = textView.intrinsicContentSize.height
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.buyerDeliveryAddress(textView.text ?? "")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true;
    }
}
