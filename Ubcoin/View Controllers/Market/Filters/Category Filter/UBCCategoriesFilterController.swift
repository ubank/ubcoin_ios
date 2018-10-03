//
//  UBCCategoriesFilterController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/3/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCCategoriesFilterController: UBViewController {

    var content: [UBTableViewRowData]?
    var selectedCategories: [UBCCategoryDM]?
    private(set) lazy var tableView: UBDefaultTableView = { [weak self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.setupRefreshControll { [weak self] in
            self?.updateInfo()
        }
        tableView.actionDelegate = self
        tableView.backgroundColor = .clear
        
        return tableView
        }()
    
    convenience init(selectedCategories: [UBCCategoryDM]?) {
        self.init()
        
        self.selectedCategories = selectedCategories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "str_category"
        
        view.addSubview(tableView)
        view.addConstraints(toFillSubview: tableView)
        
        startActivityIndicatorImmediately()
        updateInfo()
    }

    override func updateInfo() {
        UBCDataProvider.shared.categories { [weak self] success, categories in
            self?.stopActivityIndicator()
            self?.tableView.refreshControll.endRefreshing()
            
            if let content = categories as? [UBCCategoryDM] {
                self?.setupContent(categories: content)
            }
        }
    }
    
    private func setupContent(categories: [UBCCategoryDM]) {
        let rows = categories.compactMap { $0.rowData() }
        
        if let selectedCategories = selectedCategories {
            let selectedIDs = selectedCategories.compactMap { $0.id }
            let predicate = NSPredicate(format: "data.id IN %@", selectedIDs)
            let selectedRows = rows.filter { predicate.evaluate(with: $0) }
            
            for row in selectedRows {
               updateRowSelection(row: row)
            }
        }
        
        tableView.update(withRowsData: rows)
    }
    
    private func updateRowSelection(row: UBTableViewRowData) {
        row.isSelected = !row.isSelected
        
        if  row.isSelected {
            row.accessoryType = .checkmark
            row.attributedTitle = NSAttributedString(string: row.title, attributes: [.foregroundColor: UBCColor.green, .font: UBFont.titleFont])
        } else {
            row.accessoryType = .none
            row.attributedTitle = NSAttributedString(string: row.title, attributes: [.foregroundColor: UBColor.titleColor, .font: UBFont.titleFont])
        }
    }
}

extension UBCCategoriesFilterController: UBDefaultTableViewDelegate {
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        cell.tintColor = UBCColor.green
    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        updateRowSelection(row: data)
        tableView.reloadData()
    }
}
