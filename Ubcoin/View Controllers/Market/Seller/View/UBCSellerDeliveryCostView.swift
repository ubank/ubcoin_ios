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
    func confirmNewDeliveryPrice(_ dealId: String, _ price: String)
}

class UBCSellerDeliveryCostView: UIView {

    @IBOutlet weak var delegate: UBCSellerDeliveryCostViewDelegate?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buyerAddressLabel: HUBLabel!
    @IBOutlet weak var buyerAddress: HUBLabel!
    @IBOutlet weak var deliveryPriceLabel: HUBLabel!
    @IBOutlet weak var deliveryPriceCostField: UITextField!
    @IBOutlet weak var confirmNewDeliveryPriceButton: HUBGeneralButton!
    
    private var deal: UBCDealDM?
    private var previousCost = ""
    
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
        
        deliveryPriceCostField.font = UBCFont.title
        deliveryPriceCostField.textColor = UBCColor.main
        deliveryPriceCostField.addDoneToolbar()
        
        buyerAddressLabel.text = "str_buyer_address".localizedString()
        deliveryPriceLabel.text = "str_delivery_price".localizedString()
        confirmNewDeliveryPriceButton.title = "str_delivery_new_price_confirm".localizedString()
    }
    
    func setupDeal(_ deal: UBCDealDM?) {
 
        guard let deal = deal else {
            isHidden = true
            return
        }
        self.deal = deal
        
        buyerAddress.text = deal.comment == nil || deal.comment.count == 0 ? "str_no_set_delivery_address".localizedString() : deal.comment
        confirmNewDeliveryPriceButton.isHidden = true
        deliveryPriceCostField.placeholder = "IN " + deal.currencyType
        deliveryPriceCostField.text = deal.deliveryPrice
        previousCost = deal.deliveryPrice ?? "0"
    }
    @IBAction func changeDeliveryPrice(_ sender: Any) {
        deliveryPriceCostField.becomeFirstResponder()
    }
    
    @IBAction func confirmNewDeliveryPrice(_ sender: Any) {
        if let deal = deal, let price = deliveryPriceCostField.text, let delegate = delegate {
            delegate.confirmNewDeliveryPrice(deal.id, price.replacingOccurrences(of: ",", with: "."))
        }
    }
    
}

extension UBCSellerDeliveryCostView : UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        confirmNewDeliveryPriceButton.isHidden = previousCost == textField.text
    }
    
}
