//
//  UBCCurrencySelectionView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 04/02/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCCurrencySelectionViewDelegate {
    func confirm(currency: String)
}

class UBCCurrencySelectionView: UIView {

    @IBOutlet weak var delegate: UBCCurrencySelectionViewDelegate?
    
    @IBOutlet var ubcButton: UBButton!
    @IBOutlet var ethButton: UBButton!
    @IBOutlet var confirmButton: HUBGeneralButton!
    @IBOutlet var commissionLabel: HUBLabel!
    @IBOutlet var balanceLabel: HUBLabel!
    
    var isETH: Bool = false
    private var currency: String {
        return isETH ? "ETH" : "UBC"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        updateContent()
    }
    
    private func setupViews() {
        ubcButton.cornerRadius = 10
        updateButtonColor(button: ubcButton, isSelected: true)
        
        ethButton.cornerRadius = 10
        updateButtonColor(button: ethButton, isSelected: false)
        
        commissionLabel.textColor = UBColor.titleColor
    }
    
    private func updateButtonColor(button: UBButton, isSelected: Bool) {
        if isSelected {
            button.titleColor = UIColor.white
            button.backgroundColor = UBCColor.green
        } else {
            button.titleColor = UBColor.titleColor
            button.backgroundColor = UBColor.backgroundColor
        }
    }
    
    private func updateContent() {
        confirmButton.title = String(format: "%@ %@", "str_confirm_in".localizedString(), currency)
        commissionLabel.isHidden = !isETH
        
        let balance = UBCBalanceDM.loadBalance()
        let balanceAmount = isETH ? balance?.amountETH.coinsPriceString : balance?.amountUBC.priceString
        balanceLabel.text = String(format: "%@: %@ %@", "str_your_balance".localizedString(), balanceAmount ?? "", currency)
    }
    
    @IBAction func UBCSelected() {
        updateButtonColor(button: ubcButton, isSelected: true)
        updateButtonColor(button: ethButton, isSelected: false)
        
        isETH = false
        updateContent()
    }
    
    @IBAction func ETHSelected() {
        updateButtonColor(button: ubcButton, isSelected: false)
        updateButtonColor(button: ethButton, isSelected: true)
        
        isETH = true
        updateContent()
    }
    
    @IBAction func confirm() {
        
    }
}
