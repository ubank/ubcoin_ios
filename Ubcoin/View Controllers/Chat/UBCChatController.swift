//
//  UBCChatController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 22/01/2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar


class UBCChatController: UBCMessagesViewController {
    
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
        
        self.title = UBLocal.shared.localizedString(forKey: "str_chat", value: "")
        messagesCollectionView.messageCellDelegate = self
        
        UBCSocketIOManager.sharedInstance.enterRoom(item: item)
        
        UBCSocketIOManager.sharedInstance.messageListener {[weak self] message in
            guard let sself = self else {
                return
            }
            sself.insertMessage(message)
        }
        
        UBCSocketIOManager.sharedInstance.historyListener {[weak self] messages in
            guard let sself = self else {
                return
            }
            sself.setHistory(messages)

        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UBCSocketIOManager.sharedInstance.exitChat()
    }
    
    
    override func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            //            SampleData.shared.getMessages(count: 20) { messages in
            DispatchQueue.main.async {
                //self.messageList.insert(contentsOf: messages, at: 0)
                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.refreshControl.endRefreshing()
            }
            //            }
        }
    }
    
}


//MARK: - MessageCellDelegate

extension UBCChatController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}

// MARK: - MessageLabelDelegate

extension UBCChatController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}
