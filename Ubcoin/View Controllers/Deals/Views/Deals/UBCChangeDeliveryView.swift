//
//  UBCChangeDeliveryView.swift
//  Ubcoin
//
//  Created by vkrotin on 07.03.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCChangeDeliveryViewDelegate: class {
    
    func changeDeliveryTouch(_ dealId: String)
    
}

class UBCChangeDeliveryView: UIView {

    @IBOutlet weak var delegate: UBCChangeDeliveryViewDelegate?

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var descriptionLabel: HUBLabel!
    @IBOutlet weak var changeButton: HUBGeneralButton!
    
    private var dealId: String?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCChangeDeliveryView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)
        
        changeButton.addTopSeparator()
        changeButton.titleLabel?.font = UBFont.buttonFont
    }
    
    func setup(_ deal: UBCDealDM?, isMyId: Bool) {
        
        guard let deal = deal else {
            isHidden = true
            return
        }
        
        self.dealId = deal.id
        descriptionLabel.text = isMyId ? "str_delivery_seller_change".localizedString() : "str_delivery_buyer_change".localizedString()
        changeButton.title = isMyId ? "str_delivery_seller_need".localizedString() : "str_delivery_buyer_need".localizedString()
        
    }
    
    @IBAction func changeButtonTouch(_ sender: Any) {
        if let delegate = delegate, let dealId = dealId {
            delegate.changeDeliveryTouch(dealId)
        }
    }
}
