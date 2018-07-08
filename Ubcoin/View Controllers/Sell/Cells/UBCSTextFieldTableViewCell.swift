//
//  UBCSTextFieldTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSTextFieldTableViewCell: UBTableViewCell {

    static let className = String(describing: UBCSTextFieldTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
    }
}


extension UBCSTextFieldTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        
    }
}
