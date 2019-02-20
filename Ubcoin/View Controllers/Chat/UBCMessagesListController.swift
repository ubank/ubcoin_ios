//
//  UBCMessagesListController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 17/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCMessagesListController: UBViewController {

    private var deals = [UBTableViewRowData]()
    private var pageNumber: UInt = 0
    
    private lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView()
        tableView.actionDelegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_messages"
        
        setupTableView()
        
        startActivityIndicatorImmediately()
        updateInfo()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        tableView.emptyView.icon.image = UIImage(named: "chat_empty_messages")
        tableView.emptyView.title.text = "str_no_messages_title".localizedString()
        tableView.emptyView.desc.text = "str_no_messages_desc".localizedString()
        tableView.backgroundColor = UBColor.backgroundColor
        
        tableView.setupRefreshControll { [weak self] in
            self?.pageNumber = 0
            self?.updateInfo()
        }
    }
    
    override func updateInfo() {
        
        UBCDataProvider.shared.chartDealsList(completionBlock: { success, items, canLoadMore in
            print("use Chart message list")
        })
        
        UBCDataProvider.shared.dealsList(withPageNumber: pageNumber) { [weak self] success, items, canLoadMore in
            guard let self = self else { return }
            
            self.stopActivityIndicator()
            self.tableView.refreshControll.endRefreshing()
            
            if success {
                self.tableView.canLoadMore = canLoadMore
            }
            
            if let items = items as? [UBTableViewRowData] {
                if self.pageNumber == 0 {
                    self.deals = [UBTableViewRowData]()
                }
                self.deals += items
                self.pageNumber += 1
            }
            
            self.tableView.emptyView.isHidden = !self.deals.isEmpty
            self.tableView.update(withRowsData: self.deals)
        }
    }
}

extension UBCMessagesListController: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let deal = data.data as? UBCDealDM {
            navigationController?.pushViewController(UBCChatController(deal: deal), animated: true)
        }
    }
    
    func updatePagination() {
        updateInfo()
    }
}
