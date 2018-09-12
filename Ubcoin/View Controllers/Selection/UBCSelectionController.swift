//
//  UBCSelectionController.swift
//  Ubcoin
//
//  Created by Aidar on 08/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSelectionController: UBViewController {
    
    var completion: ((UBCCategoryDM) -> Void)?
    
    private var tableView: UBDefaultTableView!
    
    private var content = [UBCCategoryDM]()
    private var selected: String?
    
    convenience init(title: String, selected: String?) {
        self.init()
        
        self.title = title
        
        self.selected = selected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        
        self.updateInfo()
        self.startActivityIndicator()
    }
    
    override func updateInfo() {
        UBCDataProvider.shared.categories { [weak self] success, categories in
            self?.stopActivityIndicator()
            self?.tableView.refreshControll.endRefreshing()
            
            if let content = categories as? [UBCCategoryDM] {
                self?.content = content
            }
            self?.setupContent()
        }
    }
    
    private func setupViews() {
        self.tableView = UBDefaultTableView()
        self.tableView.actionDelegate = self
        self.tableView.setupRefreshControll { [weak self] in
            self?.updateInfo()
        }
        self.view.addSubview(self.tableView)
        self.view.addConstraints(toFillSubview: self.tableView)
    }
    
    private func setupContent() {
        var selectedRow: Int?
        if let selectedString = self.selected {
            for i in 0..<self.content.count {
                if self.content[i].id == selectedString {
                    selectedRow = i
                    break
                }
            }
        }
        
        var rows = [UBTableViewRowData]()
        for i in 0..<self.content.count {
            let row = UBTableViewRowData()
            row.height = UBCConstant.cellHeight
            
            var color = UBCColor.main
            if let selected = selectedRow, selected == i {
                row.accessoryType = .checkmark
                color = UBCColor.green
            }
            
            row.attributedTitle = NSAttributedString(string: self.content[i].name, attributes: [.foregroundColor: color, .font: UBCFont.title])
            rows.append(row)
        }
        self.tableView.update(withRowsData: rows)
    }
}


extension UBCSelectionController: UBDefaultTableViewDelegate {
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        cell.tintColor = UBCColor.green
    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let completion = self.completion {
            let category = self.content[indexPath.row]
            completion(category)
        }
    }
}
