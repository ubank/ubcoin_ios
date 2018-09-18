//
//  UBCMarketsListController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCMarketsListController: UBViewController {

    private(set) lazy var tableView: UBDefaultTableView = { [weak self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.backgroundColor = .clear
        
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "str_exchange_to_buy_UBC"
        
        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        startActivityIndicatorImmediately()
        updateInfo()
    }
    
    override func updateInfo() {
        UBCDataProvider.shared.markets { [weak self] success, markets in
            self?.stopActivityIndicator()
            if let content = markets as? [UBTableViewRowData], content.count > 0 {
                self?.tableView.update(withRowsData: content)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

}

extension UBCMarketsListController: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let url = data.data as? URL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
