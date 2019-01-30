//
//  UBCDealInfoController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 28/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCDealInfoController: UBViewController {

    private var item: UBCGoodDM?
    private var deal: UBCDealDM?
    private var content = [UBTableViewRowData]()
    
    private lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView()
        tableView.actionDelegate = self
        
        return tableView
    }()

    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
    }

    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_purchase"
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        tableView.backgroundColor = UBColor.backgroundColor
    }
}

extension UBCDealInfoController: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        
    }
}
