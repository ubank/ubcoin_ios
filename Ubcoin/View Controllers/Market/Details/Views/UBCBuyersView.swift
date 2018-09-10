//
//  UBCBuyersView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCBuyersView: UIView {

    private(set) lazy var tableView: UBDefaultTableView = { [unowned self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.backgroundColor = .clear
        
        return tableView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTableView()
    }

    func setupTableView() -> Void {
        self.addSubview(self.tableView)
        self.addConstraints(toFillSubview: self.tableView)
    }
    
    
}

extension UBCBuyersView: UBDefaultTableViewDelegate {
    
}
