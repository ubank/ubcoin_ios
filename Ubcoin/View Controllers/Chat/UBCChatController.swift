//
//  UBCChatController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 22/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit

class UBCChatController: UBViewController {

    private var item: UBCGoodDM?
    private var deal: UBCDealDM?
    
    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
    }
    
    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "str_chat";
        updateInfo()
    }
    
    override func updateInfo() {
        if let item = item {
            startActivityIndicatorImmediately()
            UBCDataProvider.shared.deal(forItemID: item.id) { [weak self] success, deal in
                self?.stopActivityIndicator()
                
                guard let self = self,
                let deal = deal else { return }
                
                self.startChat(deal: deal)
            }
        } else if let deal = deal {
            startChat(deal: deal)
        }
    }
    
    private func startChat(deal: UBCDealDM) {
        
    }
}
