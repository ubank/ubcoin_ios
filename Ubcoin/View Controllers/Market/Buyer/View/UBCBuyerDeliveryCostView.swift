//
//  UBCBuyerDeliveryCostView.swift
//  Ubcoin
//
//  Created by vkrotin on 26.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCBuyerDeliveryCostViewDelegate: class {

    func confirmDeliveryPrice(_ dealId: String, _ price: String)
    
}

class UBCBuyerDeliveryCostView: UIView {
    
    @IBOutlet weak var delegate: UBCBuyerDeliveryCostViewDelegate?

    @IBOutlet var contentView: UIView!
 
    @IBOutlet weak var buyerAddress: HUBLabel!
    @IBOutlet weak var deliveryPriceLabel: HUBLabel!
    
    @IBOutlet weak var deliveryPriceCostLabel: HUBLabel!
    @IBOutlet weak var deliveryInfo: HUBLabel!
    
    @IBOutlet weak var confirmDeliveryButton: HUBGeneralButton!
    
    private var deal: UBCDealDM?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCBuyerDeliveryCostView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)

        confirmDeliveryButton.clipsToBounds = false
        confirmDeliveryButton.titleColor = UIColor.white
        confirmDeliveryButton.backgroundColor = UBCColor.green
        
        deliveryPriceCostLabel.textColor = UBCColor.green
    }
    
    @objc func setup(deal: UBCDealDM?) {
        
        guard let deal = deal else {
            isHidden = true
            return
        }
        self.deal = deal
        
        buyerAddress.text = deal.buyer.locationText ?? ""
        
        deliveryPriceLabel.text = "str_delivery_price".localizedString() + deal.currencyType
        deliveryPriceCostLabel.text = deal.deliveryPrice
        
    }
    
    
    @IBAction func confirmDeliveryTouch(_ sender: Any) {
        if let deal = deal, let price = deliveryPriceCostLabel.text, let delegate = delegate {
            delegate.confirmDeliveryPrice(deal.id, price.replacingOccurrences(of: ",", with: "."))
        }
        
    }
    
    @IBAction func changeAddressTouch(_ sender: Any) {
    }
    
    

}
