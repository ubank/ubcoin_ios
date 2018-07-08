//
//  UBCSelectionController.swift
//  Ubcoin
//
//  Created by Aidar on 08/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSelectionController: UBViewController {
    
    var completion: ((Int) -> Void)?
    
    private var content: [String]!
    private var selected: Int?
    
    private(set) lazy var tableView: UBDefaultTableView = { [unowned self] in
        let tableView = UBDefaultTableView()
        
        tableView.actionDelegate = self
        
        return tableView
    }()
    
    init(title: String, content: [String], selected: Int?) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.content = content
        self.selected = selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupContent()
    }
    
    private func setupViews() {
        self.view.addSubview(self.tableView)
        self.view.addConstraints(toFillSubview: self.tableView)
    }
    
    private func setupContent() {
        var rows = [UBTableViewRowData]()
        for i in 0..<self.content.count {
            let string = self.content[i]
            
            let row = UBTableViewRowData()
            row.height = 65
            row.title = string
            rows.append(row)
        }
        
        self.tableView.update(withRowsData: rows)
    }
}


extension UBCSelectionController: UBDefaultTableViewDelegate {
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        cell.accessoryType = .none
        cell.tintColor = UIColor(red: 42 / 255.0, green: 42 / 255.0, blue: 42 / 255.0, alpha: 1)
        cell.title.textColor = UIColor(red: 42 / 255.0, green: 42 / 255.0, blue: 42 / 255.0, alpha: 1)
        if let selected = self.selected, selected == indexPath.row {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(red: 50 / 255.0, green: 187 / 255.0, blue: 143 / 255.0, alpha: 1)
            cell.title.textColor = UIColor(red: 50 / 255.0, green: 187 / 255.0, blue: 143 / 255.0, alpha: 1)
        }
    }
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let completion = self.completion {
            completion(indexPath.row)
        }
    }
}
