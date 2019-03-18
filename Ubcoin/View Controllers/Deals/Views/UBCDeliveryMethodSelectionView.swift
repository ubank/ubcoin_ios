//
//  UBCDeliveryMethodSelectionView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 14/02/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCDeliveryMethodSelectionView: UIView {

    static let delivery = "delivery"
    
    private var changeDeliveryBlock: ((Bool) -> Void)?
    
    var isDelivery: Bool = true {
        didSet {
            if let changeBlock = changeDeliveryBlock {
                changeBlock(isDelivery)
            }
        }
    }
    private(set) lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 190))
        
        setup()
        setupData()
    }
    
    func setup() {
         backgroundColor = UIColor.white
        
        addSubview(tableView)
        setAllConstraintToSubview(tableView, with: UIEdgeInsetsMake(15, 15, 15, -15))
    }
    
    func setupData() {
        let section = UBTableViewSectionData()
        section.footerHeight = 10
        
        let row = UBTableViewRowData()
        row.title = "str_item_will_be_delivered_to_me".localizedString()
        row.desc = "str_by_courier_or_a_delivery_service".localizedString()
        row.height = 75
        row.isSelected = isDelivery
        let icon = row.isSelected ? "checked" : "unchecked"
        row.rightIcon = UIImage(named: icon)
        row.name = UBCDeliveryMethodSelectionView.delivery
        section.rows = [row]
        
        let section2 = UBTableViewSectionData()
        
        let row2 = UBTableViewRowData()
        row2.title = "str_i_will_meet_seller_in_person".localizedString()
        row2.desc = "str_for_a_handshake".localizedString()
        row2.height = 75
        row2.isSelected = !isDelivery
        let icon2 = row2.isSelected ? "checked" : "unchecked"
        row2.rightIcon = UIImage(named: icon2)
        section2.rows = [row2]
        
        tableView.update(withSectionsData: [section, section2])
    }
    
}

extension UBCDeliveryMethodSelectionView: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        if let name = data.name,
            name == UBCDeliveryMethodSelectionView.delivery {
            isDelivery = true
        } else {
            isDelivery = false
        }
        
        setupData()
    }
    
    func prepare(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!) {
        cell.cornerRadius = 10
        cell.borderWidth = 1
    }
    
    func layoutCell(_ cell: UBDefaultTableViewCell!, for data: UBTableViewRowData!, indexPath: IndexPath!) {
        if data.isSelected {
            cell.borderColor = UBCColor.green
        } else {
            cell.borderColor = UBColor.separatorColor
        }
    }
    
    func changeDelivery(_ completion: ((Bool) -> Void)?) {
        changeDeliveryBlock = completion
    }
    
}
