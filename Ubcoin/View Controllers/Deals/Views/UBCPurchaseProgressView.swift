//
//  UBCPurchaseProgressView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 14/02/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCPurchaseProgressView: UIView {

    private(set) lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()

}

extension UBCPurchaseProgressView: UBDefaultTableViewDelegate {
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        
    }
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        
    }
}
