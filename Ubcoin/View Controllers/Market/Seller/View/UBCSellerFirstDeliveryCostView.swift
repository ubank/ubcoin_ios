//
//  UBCSellerFirstDeliveryCostView.swift
//  Ubcoin
//
//  Created by vkrotin on 26.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

//@objc
//protocol UBCBuyerDeliveryCostViewDelegate: class {
//
//    func confirmDeliveryPrice(_ dealId: String, _ price: String)
//    
//}

class UBCSellerFirstDeliveryCostView: UIView {
    
    @IBOutlet weak var delegate: UBCSellerDeliveryCostViewDelegate?

    @IBOutlet var contentView: UIView!
 
    @IBOutlet weak var buyerAddressLabel: HUBLabel!
    @IBOutlet weak var buyerAddress: HUBLabel!
    
    @IBOutlet weak var deliveryPriceLabel: HUBLabel!
    @IBOutlet weak var deliveryPiceTextField: UBTextField!
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
        Bundle.main.loadNibNamed("UBCSellerFirstDeliveryCostView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)

        confirmDeliveryButton.clipsToBounds = false
        confirmDeliveryButton.titleColor = UIColor.white
        confirmDeliveryButton.backgroundColor = UBCColor.green
        
        deliveryPiceTextField.font = UBCFont.title
        deliveryPiceTextField.textColor = UBCColor.green
        deliveryPiceTextField.addDoneToolbar()
        
        buyerAddressLabel.text = "str_buyer_address".localizedString()
        deliveryPriceLabel.text = "str_delivery_price".localizedString()
        deliveryInfo.text = "str_delivery_price_is_0".localizedString()
        confirmDeliveryButton.title = "str_delivery_price_confirm".localizedString()
    }
    
    @objc func setup(_ deal: UBCDealDM?) {
        
        guard let deal = deal else {
            isHidden = true
            return
        }
        self.deal = deal
        
        buyerAddress.text = deal.comment == nil || deal.comment.count == 0 ? "str_no_set_delivery_address".localizedString() : deal.comment
        deliveryPiceTextField.placeholder = "IN " + deal.currencyType
    }
    
    
    @IBAction func confirmDeliveryTouch(_ sender: Any) {
        if let deal = deal, let delegate = delegate {
             let price = deliveryPiceTextField.text ?? "0"
            delegate.confirmNewDeliveryPrice(deal.id, price.replacingOccurrences(of: ",", with: "."))
        }
    }
    

}
