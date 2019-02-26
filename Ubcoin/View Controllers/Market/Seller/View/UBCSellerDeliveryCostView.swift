//
//  UBCSellerDeliveryCostView.swift
//  Ubcoin
//
//  Created by vkrotin on 26.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCSellerDeliveryCostViewDelegate: class {
    func changeDeliveryPrice(_ seller: UBCSellerDM)
    func confirmNewDeliveryPrice(_ seller: UBCSellerDM)
}

class UBCSellerDeliveryCostView: UIView {

    @IBOutlet weak var delegate: UBCSellerDeliveryCostViewDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buyerAddress: HUBLabel!
    @IBOutlet weak var deliveryPriceLabel: HUBLabel!
    @IBOutlet weak var deliveryPriceCostLabel: HUBLabel!
    
    @IBOutlet weak var confirmNewDeliveryPriceButton: HUBGeneralButton!
    
    @IBOutlet weak var heightDeliveryButton: NSLayoutConstraint!
    private var seller: UBCSellerDM?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCSellerDeliveryCostView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)
        
        confirmNewDeliveryPriceButton.clipsToBounds = false
        confirmNewDeliveryPriceButton.titleColor = UIColor.white
        confirmNewDeliveryPriceButton.backgroundColor = UBCColor.green
    }
    
    func hideButton(_ isHide:Bool = false) {
        confirmNewDeliveryPriceButton.isHidden = isHide
        heightDeliveryButton.constant = isHide == false ? 36 : 0
        updateConstraintsIfNeeded()
    }
    
    @IBAction func changeDeliveryPriceTouch(_ sender: Any) {
        if let seller = seller {
            delegate?.changeDeliveryPrice(seller)
        }
    }
    
    @IBAction func confirmNewDeliveryPrice(_ sender: Any) {
        if let seller = seller {
            delegate?.confirmNewDeliveryPrice(seller)
        }
    }
    
}
