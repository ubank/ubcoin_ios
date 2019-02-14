//
//  UBCDeliverySelectionView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 12/02/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCDeliverySelectionViewDelegate {
    func showSellerLocation()
}

class UBCDeliverySelectionView: UIView {

    @IBOutlet weak var delegate: UBCDeliverySelectionViewDelegate?
    
    var isDelivery: Bool {
        return footerView.isDelivery
    }
    
    private(set) lazy var footerView: UBCDeliveryMethodSelectionView = {
            return UBCDeliveryMethodSelectionView()
    }()
    
    private(set) lazy var tableView: UBDefaultTableView = {
        let tableView = UBDefaultTableView(frame: .zero, style: .grouped)
        
        tableView.actionDelegate = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(tableView)
        addConstraints(toFillSubview: tableView)
        
        tableView.tableFooterView = footerView
    }
    
    func setup(item: UBCGoodDM) {
        
        let section = UBTableViewSectionData()
        section.headerTitle = "str_seller_location_up".localizedString()
        section.footerHeight = 10
        
        let row = UBTableViewRowData()
        row.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        row.icon = UIImage(named: "location")
        row.title = item.locationText
        row.desc = UBLocationManager.distanceString(fromMeAndCoordinates: item.location.coordinate)
        section.rows = [row]
        
        tableView.update(withSectionsData: [section])
    }
}

extension UBCDeliverySelectionView: UBDefaultTableViewDelegate {
    
    func didSelect(_ data: UBTableViewRowData!, indexPath: IndexPath!) {
        delegate?.showSellerLocation()
    }
}
