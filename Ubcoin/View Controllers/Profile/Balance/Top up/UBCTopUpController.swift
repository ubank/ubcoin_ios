//
//  UBCTopUpController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCTopUpController: UBViewController {

    @IBOutlet weak var timerLabel: UBCTimerLabel!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var copyButton: HUBGeneralButton!
    
    private var topup: UBCTopupDM?
    
    @objc
    convenience init(topup: UBCTopupDM) {
        self.init()
        self.topup = topup
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timerLabel.stopTimer()
    }
    
    private func setupViews() {
        timerLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        timerLabel.textColor = UBCColor.green
        
        address.backgroundColor = UBColor.backgroundColor;
        address.cornerRadius = 4.5;
        address.font = UBFont.descFont;
        address.textColor = UBColor.titleColor;
        
        copyButton.backgroundColor = UBCColor.green
        copyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16);
    }
    
    private func setupContent() {
        address.text = topup?.address
        if let endTime = topup?.walletExpirationDate.timeIntervalSince1970 {
            let leftSeconds = endTime - Date().timeIntervalSince1970
            timerLabel.setup(seconds: Int64(leftSeconds))
        }
    }
    
    @IBAction func copyAddressToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = address.text;
        UBToast.show(withMessage: "str_address_copied_to_clipboard")
    }
}
