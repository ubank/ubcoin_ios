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
    func confirmDelivery(seller: UBCSellerDM)
    func showBuyerLocation()
}

class UBCBuyerDeliveryCostView: UIView {
    
    @IBOutlet weak var delegate: UBCBuyerDeliveryCostViewDelegate?

    @IBOutlet var contentView: UIView!
 
    @IBOutlet weak var buyerAddress: HUBLabel!
    @IBOutlet weak var deliveryPriceLabel: HUBLabel!
    
    @IBOutlet weak var deliveryPriceCostLabel: HUBLabel!
    @IBOutlet weak var deliveryInfo: HUBLabel!
    
    @IBOutlet weak var confirmDeliveryButton: HUBGeneralButton!
    
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
        Bundle.main.loadNibNamed("UBCBuyerDeliveryCostView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)

        confirmDeliveryButton.clipsToBounds = false
        confirmDeliveryButton.titleColor = UIColor.white
        confirmDeliveryButton.backgroundColor = UBCColor.green
        
        deliveryPriceCostLabel.textColor = UBCColor.green
    }
    
    @objc func setup(seller: UBCSellerDM?, isSeller: Bool) {
        self.seller = seller
        
//        guard let seller = seller else { return }
//
//        chatButton.title = isSeller ? "str_chat_with_seller".localizedString() : "str_chat_with_buyer".localizedString()
//        avatar.sd_setImage(with: URL(string: seller.avatarURL ?? ""),
//                           placeholderImage: UIImage(named: "def_prof"),
//                           options: [],
//                           completed: nil)
//        name.text = seller.name
//        rating.showStars(seller.rating.uintValue)
//
//        desc.text = String(format: "%lu items", seller.itemsCount)
    }
    
    
    @IBAction func confirmDeliveryTouch(_ sender: Any) {
        if let seller = seller {
            delegate?.confirmDelivery(seller: seller)
        }
        
    }
    
    @IBAction func changeAddressTouch(_ sender: Any) {
        if let delegate = delegate {
            delegate.showBuyerLocation()
        }
    }
    
    

}
