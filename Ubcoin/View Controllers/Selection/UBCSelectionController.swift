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
    
    private var tableView: UBDefaultTableView!
    
    private var content: [String]!
    private var selected: Int?
    
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
        self.tableView = UBDefaultTableView()
        self.tableView.actionDelegate = self
        self.view.addSubview(self.tableView)
        self.view.addConstraints(toFillSubview: self.tableView)
    }
    
    private func setupContent() {
        var rows = [UBTableViewRowData]()
        for i in 0..<self.content.count {
            let row = UBTableViewRowData()
            row.height = UBCConstant.cellHeight
            
            var color = UBColor.titleColor
            if let selected = self.selected, selected == i {
                row.accessoryType = .checkmark
                color = UBCColor.green
            }
            
            row.attributedTitle = NSAttributedString(string: self.content[i], attributes: [.foregroundColor: color!])
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
            completion(indexPath.row)
        }
    }
}
