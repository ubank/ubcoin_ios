//
//  UBCSMapTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 18/08/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSMapTableViewCell: UBTableViewCell {

    static let className = String(describing: UBCSMapTableViewCell.self)
    
    private var mapView: UBCMapView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.mapView = UBCMapView()
        self.mapView.isUserInteractionEnabled = false
        self.contentView.addSubview(self.mapView)
        self.contentView.addConstraints(toFillSubview: self.mapView)
    }
}


extension UBCSMapTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        guard let dict = content.sendData as? [String: Any], let lat = dict["latPoint"] as? Double, let long = dict["longPoint"] as? Double else { return }
        
        self.mapView.location = CLLocation(latitude: lat, longitude: long)
    }
}
