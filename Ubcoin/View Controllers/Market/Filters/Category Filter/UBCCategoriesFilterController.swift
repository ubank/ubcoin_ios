//
//  UBCCategoriesFilterController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/3/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCCategoriesFilterController: UBViewController {

    @objc var completion: (([UBCFilterParam]) -> Void)?
    
    var content: [UBTableViewRowData]?
    var selectedCategories: [UBCFilterParam]?
    private(set) lazy var tableView: UBDefaultTableView = { [weak self] in
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.setupRefreshControll { [weak self] in
            self?.updateInfo()
        }
        tableView.actionDelegate = self
        tableView.backgroundColor = .clear
        
        return tableView
        }()
    
    //MARK: -
    
    @objc convenience init(selectedCategories: [UBCFilterParam]?) {
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
    
    override func navigationButtonBackClick(_ sender: Any?) {
        if let completion = self.completion {
            completion(seletedFilters())
        }
        
        super.navigationButtonBackClick(sender)
    }
    
    //MARK: -
    
    private func setupContent(categories: [UBCCategoryDM]) {
        var rows = categories.compactMap { $0.rowData() }
        rows.insert(UBCCategoryDM.allCategoriesData(), at: 0)
        
        content = rows
        
        if let selectedCategories = selectedCategories {
            let selectedIDs = selectedCategories.compactMap { $0.value }
            let predicate = NSPredicate(format: "data.ID IN %@", selectedIDs)
            let selectedRows = rows.filter { predicate.evaluate(with: $0) }
            
            if selectedRows.count > 0 {
                for row in selectedRows {
                    updateRowSelection(row: row)
                }
            } else {
                updateRowSelection(row: rows[0])
            }
        } else {
            updateRowSelection(row: rows[0])
        }
        
        tableView.update(withRowsData: content)
    }
    
    private func updateRowSelection(row: UBTableViewRowData) {
        
        if row.data == nil { //all categories
            select(row: row)
        } else {
            if  row.isSelected {
                deselect(row: row)
            } else {
                select(row: row)
            }
        }
        
        if let rows = content {
            let selectedRowsData = selectedRows()
            
            let dataPredicate = NSPredicate(format: "data == nil")
            if selectedRowsData.count > 0 {
                if row.data == nil {
                    for row in selectedRowsData {
                        if row.data != nil {
                            deselect(row: row)
                        }
                    }
                } else {
                    let selectedRowsWithoutData = selectedRowsData.filter { dataPredicate.evaluate(with: $0) }
                    _ = selectedRowsWithoutData.compactMap { deselect(row: $0) }
                }
            } else {
                let rowsWithoutData = rows.filter { dataPredicate.evaluate(with: $0) }
                _ = rowsWithoutData.compactMap { select(row: $0) }
            }
        }
    }
    
    private func select(row: UBTableViewRowData) {
        row.isSelected = true
        row.accessoryType = .checkmark
        row.attributedTitle = NSAttributedString(string: row.title, attributes: [.foregroundColor: UBCColor.green, .font: UBFont.titleFont])
    }
    
    private func deselect(row: UBTableViewRowData) {
        row.isSelected = false
        row.accessoryType = .none
        row.attributedTitle = NSAttributedString(string: row.title, attributes: [.foregroundColor: UBColor.titleColor, .font: UBFont.titleFont])
    }
    
    private func selectedRows() -> [UBTableViewRowData] {
        if let rows = content {
            return rows.filter { $0.isSelected == true }
        } else {
            return []
        }
    }
    
    private func seletedFilters() -> [UBCFilterParam] {
        return selectedRows().compactMap { UBCFilterParam.init(category: $0.data as? UBCCategoryDM) }
    }
}

//MARK: -

extension UBCCategoriesFilterController: UBDefaultTableViewDelegate {
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        cell.tintColor = UBCColor.green
    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        updateRowSelection(row: data)
        tableView.reloadData()
    }
}
