//
//  UBCDealInfoController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 28/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCDealInfoController: UBViewController {

    @IBOutlet weak var scroll: UIScrollView!
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
    
    @IBOutlet weak var actionButton: HUBGeneralButton!
    
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
            deliveryView.isHidden = item.isDigital || purchaseDM.isPurchase
    
            let person = item.isMyItem ? purchaseDM.deal?.buyer : purchaseDM.seller
            sellerView.setup(seller: person, isSeller: !item.isMyItem)
        }
        
        statusTitle.text = purchaseDM.longStatusTitle
        statusTitle.isHidden = statusTitle.text?.isEmpty == true
        statusDesc.text = purchaseDM.longStatusDesc
        statusDesc.isHidden = statusDesc.text?.isEmpty == true

        paymentContainerView.isHidden = purchaseDM.isPurchase
        progressContainerView.isHidden = !purchaseDM.isPurchase
        
        actionButton.isHidden = !purchaseDM.isPurchase
        actionButton.title = purchaseDM.actionButtonTitle
    }
    
    //MARK: - Actions
    
    @IBAction func showItem() {
        if let controller = UBCGoodDetailsController(good: purchaseDM?.item) {        
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func footerAction() {
        
        guard let deal = purchaseDM?.deal else { return }
        
        startActivityIndicator()
        UBCDataProvider.shared.cancelDeal(deal.id) { [weak self] success in
            self?.stopActivityIndicator()
            
            if success {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func confirmPurchase(currency: String) {
        guard let item = purchaseDM?.item else { return }
        
        startActivityIndicator()
        UBCDataProvider.shared.buyItem(item.id,
                                       isDelivery: deliveryView.isDelivery,
                                       currency: currency) { [weak self] success, deal in
                                        self?.stopActivityIndicator()
                                        
                                        if let deal = deal {
                                            self?.purchaseDM = UBCPurchaseDM(deal: deal)
                                            self?.setupContent()
                                        }
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
    
    func confirm(isETH: Bool, currency: String) {
        
        guard let balance = UBCBalanceDM.loadBalance(),
            let item = purchaseDM?.item else { return }
        
        if isETH {
            if balance.amountETH.doubleValue > item.priceInETH.doubleValue {
                let title = item.priceInETH.coinsPriceString + " ETH " + "str_will_be_blocked_on_your_wallet".localizedString()
                UBAlert.show(withTitle: title,
                             andMessage: "str_confirm_purchase".localizedString(),
                             titleButtonMain: "str_confirm",
                             titleButtonCancel: "ui_button_cancel") { index in
                                if index != CANCEL_INDEX {
                                    self.confirmPurchase(currency: currency)
                                }
                }
            } else {
                UBAlert.show(withTitle: "str_please_top_up_your_balance", andMessage: "str_you_don_have_enough_eth_on_your_wallet")
            }
        } else {
            if balance.amountUBC.doubleValue > item.price.doubleValue {
                let title = item.price.priceString + " UBC " + "str_will_be_blocked_on_your_wallet".localizedString()
                UBAlert.show(withTitle: title,
                             andMessage: "str_confirm_purchase".localizedString(),
                             titleButtonMain: "str_confirm",
                             titleButtonCancel: "ui_button_cancel") { index in
                                if index != CANCEL_INDEX {
                                    self.confirmPurchase(currency: currency)
                                }
                }
            } else {
                UBAlert.show(withTitle: "str_please_top_up_your_balance", andMessage: "str_you_don_have_enough_ubc_on_your_wallet")
            }
        }
    }
}

extension UBCDealInfoController: UBCDeliverySelectionViewDelegate {
   
    func showSellerLocation() {
        let controller = UBCMapSelectController(title: "str_seller_location", location: purchaseDM?.item?.location)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
