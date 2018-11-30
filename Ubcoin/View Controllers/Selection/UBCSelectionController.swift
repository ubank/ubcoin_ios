//
//  UBCSelectionController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11/28/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSelectionController: UBViewController {

    var completion: ((UBTableViewRowData) -> Void)?
    private var content = [UBTableViewRowData]()
    
    private lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView()
        tableView.actionDelegate = self
        
        return tableView
    }()
    
    convenience init(title: String, content: [UBTableViewRowData]) {
        self.init()
        
        self.title = title
        
        self.content = content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        tableView.update(withRowsData: content)
    }
}

extension UBCSelectionController: UBDefaultTableViewDelegate {
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        cell.tintColor = UBCColor.green
    }
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        cell.title.textColor = data.isSelected ? UBCColor.green : UBColor.titleColor
    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let completion = self.completion {
            let item = content[indexPath.row]
            completion(item)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
