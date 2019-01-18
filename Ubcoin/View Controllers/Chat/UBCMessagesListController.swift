//
//  UBCMessagesListController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 17/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCMessagesListController: UBViewController {

    private var content = [UBTableViewRowData]()
    
    private lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView()
        tableView.actionDelegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_messages"
        
        setupTableView()
        updateInfo()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        tableView.emptyView.icon.image = UIImage(named: "chat_empty_messages")
        tableView.emptyView.title.text = "str_no_messages_title".localizedString()
        tableView.emptyView.desc.text = "str_no_messages_desc".localizedString()
        tableView.backgroundColor = UBColor.backgroundColor
    }
    
    override func updateInfo() {
        tableView.emptyView.isHidden = false
    }
}

extension UBCMessagesListController: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        
    }
}
