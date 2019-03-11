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
    
    private var unreadMessageCount =  0 {
        didSet {
            tabBarItem.badgeColor = UIColor.red
            tabBarItem.badgeValue = unreadMessageCount != 0 ? "" : nil
            UBCNotificationDM.needShowChatBadge = unreadMessageCount > 0
            
        }
    }
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        unreadMessageCount = 0
        pageNumber = 0
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
            self?.unreadMessageCount = 0
            self?.updateInfo()
        }
    }
    
    
    override func updateInfo(withPushParams params: [AnyHashable : Any]!) {
        pageNumber = 0
        unreadMessageCount = 0
        updateInfo()
    }
    
    override func updateInfo() {
        
        UBCDataProvider.shared.chartDealsList(completionBlock: {[weak self] success, items, canLoadMore in
            print("use Chart message list")
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

        })
    }

}

//MARK: UBDefaultTableViewDelegate

extension UBCMessagesListController: UBDefaultTableViewDelegate {
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        guard let chatDeal = data.data as? UBCChatRoom else {
            return
        }
        
        let unreadCount = chatDeal.unreadCount
        unreadMessageCount += unreadCount
        
        cell.badgeView.isHidden = unreadCount == 0

    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        
        if let chatDeal = data.data as? UBCChatRoom {
            navigationController?.pushViewController(UBCChatController(chatDeal: chatDeal), animated: true)
        }
    }
    
    func updatePagination() {
        updateInfo()
    }
}
