//
//  UBCDealInfoController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 28/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCDealInfoController: UBViewController {

    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemTitle: HUBLabel!
    @IBOutlet weak var itemDesc: HUBLabel!
    
    @IBOutlet weak var deliveryView: UBCDeliverySelectionView!
    
    @IBOutlet weak var statusTitle: HUBLabel!
    @IBOutlet weak var statusDesc: HUBLabel!
    
    @IBOutlet weak var sellerView: UBCSellerView!
    
    @IBOutlet weak var progressContainerView: UIView!
    
    @IBOutlet weak var paymentContainerView: UIView!
    @IBOutlet weak var itemPrice: HUBLabel!
    
    
    private var purchaseDM: UBCPurchaseDM?
    private var content = [UBTableViewRowData]()

    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.purchaseDM = UBCPurchaseDM(item: item)
    }

    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.purchaseDM = UBCPurchaseDM(deal: deal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_purchase"
        
        setupViews()
        setupContent()
    }
    
    private func setupViews() {
        itemIcon.cornerRadius = 5
        sellerView.delegate = self
    }
    
    private func setupContent() {
        guard let purchaseDM = purchaseDM else { return }
        
        if let item = purchaseDM.item {
            let itemIconURL = URL(string: item.imageURL ?? "")
            itemIcon.sd_setImage(with: itemIconURL, completed: nil)
            itemTitle.text = item.title
            
            let itemPriceString = String(format: "%@ UBC / %@ ETH", item.price.priceString, item.priceInETH.coinsPriceString)
            itemDesc.text = itemPriceString
            itemPrice.text = itemPriceString
            
            deliveryView.setup(item: item)
        }
        
        statusTitle.text = purchaseDM.longStatusTitle
        statusTitle.isHidden = statusTitle.text?.isEmpty == true
        statusDesc.text = purchaseDM.longStatusDesc
        statusDesc.isHidden = statusDesc.text?.isEmpty == true
        
        sellerView.setup(seller: purchaseDM.item?.seller)
        progressContainerView.isHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction func showItem() {
        if let controller = UBCGoodDetailsController(good: purchaseDM?.item) {        
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension UBCDealInfoController: UBCSellerViewDelegate {
    func show(seller: UBCSellerDM) {
        let controller = UBCSellerController(seller: seller)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func chat(seller: UBCSellerDM) {
        if let controller = UBCChatController(item: purchaseDM?.item) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension UBCDealInfoController: UBCCurrencySelectionViewDelegate {
    
    func confirm(currency: String) {
        
    }
}

extension UBCDealInfoController: UBCDeliverySelectionViewDelegate {
   
    func showSellerLocation() {
        let controller = UBCMapSelectController(title: "str_seller_location", location: purchaseDM?.item?.location)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
