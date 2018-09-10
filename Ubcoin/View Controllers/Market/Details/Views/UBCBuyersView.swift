//
//  UBCBuyersView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCBuyersView: UIView {

    var buyers: Array<UBTableViewSectionData>?
    
    private(set) lazy var tableView: UBDefaultTableView = { [unowned self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.isScrollEnabled = false
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
    
    @objc public func update(buyers: Array<UBCSellerDM>) -> Void {
        self.buyers = self.setupSections(buyers: buyers)
        self.tableView.update(withSectionsData: self.buyers)
        self.setHeightConstraintWithValue(self.tableView.contentHeight)
    }
    
    private func setupSections(buyers:Array<UBCSellerDM>) -> Array<UBTableViewSectionData> {
        
        var sections = [UBTableViewSectionData]()
        
        var reservedBuyers = [UBTableViewRowData]()
        var otherBuyers = [UBTableViewRowData]()
        for buyer in buyers {
            if buyer.status == "RESERVED" {
                reservedBuyers.append(buyer.rowData())
            } else {
                otherBuyers.append(buyer.rowData())
            }
        }
        
        if  reservedBuyers.count > 0 {
            let section = UBTableViewSectionData()
            section.headerTitle = "str_item_status_reserved".localizedString()
            section.rows = reservedBuyers
            sections.append(section)
        }
        
        let section = UBTableViewSectionData()
        if reservedBuyers.count > 0 {
            section.headerTitle = "str_others".localizedString()
        } else {        
            section.headerHeight = SEPARATOR_HEIGHT;
        }
        section.rows = otherBuyers
        sections.append(section)
        
        return sections;
    }
}

extension UBCBuyersView: UBDefaultTableViewDelegate {
    
}
