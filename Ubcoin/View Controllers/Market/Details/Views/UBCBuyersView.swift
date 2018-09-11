//
//  UBCBuyersView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCBuyersViewDelegate: AnyObject {
    @objc func didSelect(deal: UBCDealDM)
}

class UBCBuyersView: UIView {

    @IBOutlet weak var delegate: UBCBuyersViewDelegate?
    private var deals: [UBCDealDM]?
    
    private(set) lazy var tableView: UBDefaultTableView = { [unowned self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        return tableView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }

    private func setupTableView() {
        addSubview(self.tableView)
        addConstraints(toFillSubview: tableView)
    }
    
    @objc func update(deals: Array<UBCDealDM>) {
        self.deals = deals
        tableView.update(withSectionsData: setupSections(deals: deals))
        setHeightConstraintWithValue(tableView.contentHeight)
    }
    
    private func setupSections(deals:Array<UBCDealDM>) -> Array<UBTableViewSectionData> {
        
        var sections = [UBTableViewSectionData]()
        
        var reservedBuyers = [UBTableViewRowData]()
        var otherBuyers = [UBTableViewRowData]()
        for deal in deals {
            if deal.status == "ACTIVE" {
                reservedBuyers.append(deal.buyer.rowData())
            } else {
                otherBuyers.append(deal.buyer.rowData())
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
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let indexPath = indexPath, let deal = deals?[indexPath.row] {
            delegate?.didSelect(deal: deal)
        }
    }
}
