//
//  UBCBuyerDeliveryConfirmedView.swift
//  Ubcoin
//
//  Created by vkrotin on 06.03.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCBuyerDeliveryConfirmedDelegate: class {
    func confirmDeliveryPrice(_ dealId: String, _ price: String, _ needTopUpYourBalance: Bool, _ needTopBalanceText: String, _ alertMessageText: String)
}

class UBCBuyerDeliveryConfirmedView: UIView {

    @IBOutlet weak var delegate: UBCBuyerDeliveryConfirmedDelegate?
    

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var deliveryAddressLabel: HUBLabel!
    @IBOutlet weak var deliveryPrice: HUBLabel!
    @IBOutlet private weak var yourBalance: HUBLabel!
    @IBOutlet weak var confirmButton: HUBGeneralButton!
    
    private var dealId : String?
    private var dealDeliveryPrice : String?
    
    private var isETH = false
    private var isTopUpYourBalance = false
    
    private var needTopBalanceText = ""
    private var alertMessageText = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCBuyerDeliveryConfirmedView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)
        
        confirmButton.clipsToBounds = false
        confirmButton.titleColor = UIColor.white
        confirmButton.backgroundColor = UBCColor.green

        deliveryAddressLabel.text = "str_delivery_price_buyer".localizedString()
        confirmButton.title = "str_confirm_simple".localizedString()
        
    }
    
    func setup(_ deal: UBCDealDM?) {
        
        guard let deal = deal, let price = deal.deliveryPrice else {
            isHidden = true
            return
        }
        
        dealId = deal.id
        dealDeliveryPrice = price.replacingOccurrences(of: ",", with: ".")
        deliveryPrice.text = price + " " + deal.currencyType
        
        isETH = deal.currencyType == "ETH"
        
        if let balance = UBCBalanceDM.loadBalance(), let balanceAmount = isETH ? balance.amountETH.coinsPriceString : balance.amountUBC.priceString, let deliveryDoublePrice = Double(price.replacingOccurrences(of: ",", with: ".")) {
            
            yourBalance.text = "str_your_balance".localizedString() + ": " + balanceAmount + " " + deal.currencyType
            
            if isETH {
                isTopUpYourBalance = balance.amountETH.doubleValue < deliveryDoublePrice
            }
            else {
                isTopUpYourBalance = balance.amountUBC.doubleValue < deliveryDoublePrice
            }
            
            needTopBalanceText = isETH ? "str_you_don_have_enough_eth_on_your_wallet" : "str_you_don_have_enough_ubc_on_your_wallet"
            alertMessageText = deal.deliveryPrice + " " + deal.currencyType + " " + "str_will_be_blocked_on_your_wallet".localizedString()
        }
    }

    @IBAction func confirmButtonTouch(_ sender: Any) {
        guard let dealId = dealId, let dealDeliveryPrice = dealDeliveryPrice, let delegate = delegate else {
            return
        }
        
        delegate.confirmDeliveryPrice(dealId, dealDeliveryPrice, isTopUpYourBalance, needTopBalanceText, alertMessageText)
    }
}
