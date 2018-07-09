//
//  UBCSTextViewTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSTextViewTableViewCell: UBTableViewCell {

    static let className = String(describing: UBCSTextViewTableViewCell.self)
    
    var delegate: UBCSTextCellDelegate?
    
    private var content: UBCSellCellDM?
    
    private var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let offset = (UBCConstant.cellHeight - UBFont.titleFont.lineHeight) / 2
        
        self.textView = UITextView()
        self.textView.delegate = self
        self.textView.font = UBFont.titleFont
        self.textView.isScrollEnabled = false
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = .zero
        self.contentView.addSubview(self.textView)
        self.contentView.setTopConstraintToSubview(self.textView, withValue: offset)
        self.contentView.setBottomConstraintToSubview(self.textView, withValue: -offset)
        self.contentView.setLeadingConstraintToSubview(self.textView, withValue: UBCConstant.inset)
        self.contentView.setTrailingConstraintToSubview(self.textView, withValue: -UBCConstant.inset)
        self.textView.setHeightConstraintWithValue(UBFont.titleFont.lineHeight, relatedBy: .greaterThanOrEqual)
    }
}


extension UBCSTextViewTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = self.delegate, var content = self.content {
            content.data = textView.text
            delegate.updatedRow(content)
        }
        
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height
        
        if startHeight != calcHeight {
            UIView.setAnimationsEnabled(false)
            
            textView.setHeightConstraintWithValue(calcHeight, relatedBy: .greaterThanOrEqual)
            
            if let delegate = self.delegate {
                delegate.updateTableView()
            }
            
            UIView.setAnimationsEnabled(true)
        }
    }
}


extension UBCSTextViewTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        self.content = content
        
        if let text = content.data as? String {
            self.textView.text = text
        }
    }
}
