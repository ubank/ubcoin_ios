//
//  UBCSTextViewTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSTextViewTableViewCell: UBTableViewCell {
    
    static let defaultCell = UBCSTextViewTableViewCell()

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
        self.textView = UITextView()
        self.textView.delegate = self
        self.textView.font = UBCFont.title
        self.textView.isScrollEnabled = false
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = .zero
        self.contentView.addSubview(self.textView)
        self.contentView.setTopConstraintToSubview(self.textView, withValue: 10)
        self.contentView.setBottomConstraintToSubview(self.textView, withValue: -10)
        self.contentView.setLeadingConstraintToSubview(self.textView, withValue: UBCConstant.inset)
        self.contentView.setTrailingConstraintToSubview(self.textView, withValue: -UBCConstant.inset)
    }
    
    var cellHeight: CGFloat {
        let value = self.textView.sizeThatFits(CGSize(width: self.width - 2 * UBCConstant.inset, height: CGFloat.greatestFiniteMagnitude)).height + 20
        
        return value > UBCConstant.cellHeight ? value : UBCConstant.cellHeight
    }
}


extension UBCSTextViewTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = self.delegate, var content = self.content {
            content.data = textView.text
            content.sendData = content.data
            delegate.updatedRow(content)
        }
        
        let startHeight = self.height
        let calcHeight = self.cellHeight
        
        if abs(startHeight - calcHeight) >= 1 {
            UIView.setAnimationsEnabled(false)
            
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
        
        self.textView.text = content.data as? String
    }
}
