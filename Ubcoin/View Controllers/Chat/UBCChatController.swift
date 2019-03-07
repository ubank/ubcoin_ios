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
    
    private var isAppendHistory = false
    
    private var itemID: String?
    private var userID: String?
    private var item: UBCGoodDM?
    private var deal: UBCDealDM?
    private var chatDeal: UBCChatRoom?
    
    private var currentItem: UBCGoodDM? {
        if let item = item {
            return item
        } else if let item = deal?.item {
            return item
        }
        
        return chatDeal?.item
    }
    
    @objc convenience init(item: UBCGoodDM) {
        self.init()
        
        self.item = item
    }
    
    @objc convenience init(deal: UBCDealDM) {
        self.init()
        
        self.deal = deal
    }
    
    @objc convenience init(chatDeal: UBCChatRoom) {
        self.init()
        self.chatDeal = chatDeal
    }
    
    @objc convenience init?(itemID: String?, userID: String?) {
        
        guard let itemID = itemID, let userID = userID else { return nil }
        
        self.init()
        self.itemID = itemID
        self.userID = userID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemID = itemID, let userID = userID {
            UBCDataProvider.shared.chat(forUser: userID, andItem: itemID) { [weak self] success, chatRoom in
                
                guard let chatRoom = chatRoom else {
                    self?.navigationController?.popViewController(animated: true)
                    return
                }
                
                self?.chatDeal = chatRoom
                self?.setupChat()
            }
        } else {
            setupChat()
        }
    }
    
    private func setupChat() {
        
        if let item = item {
            self.navigationItem.setTitle(title: item.title, subtitle: item.seller.name)
            UBCSocketIOManager.sharedInstance.enterRoom(item)
        } else if let chatDeal = chatDeal {
            self.navigationItem.setTitle(title: chatDeal.item.title, subtitle: chatDeal.user.name)
            UBCSocketIOManager.sharedInstance.enterRoom(chatDeal)
        } else if let deal = deal {
            
            self.navigationItem.setTitle(title: deal.item.title, subtitle: deal.buyer.name)
            UBCSocketIOManager.sharedInstance.enterRoom(deal)
        }
        
        self.navigationItem.rightBarButtonItem = itemNavButton()
        
        messagesCollectionView.messageCellDelegate = self
        
        UBCSocketIOManager.sharedInstance.messageListener { [weak self] message in
            guard let sself = self else {
                return
            }
            sself.insertMessage(message)
        }
        
        UBCSocketIOManager.sharedInstance.historyListener { [weak self] messages in
            guard let sself = self else {
                return
            }
            sself.setHistory(messages, append: sself.isAppendHistory)
            sself.isAppendHistory = false
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func loadMoreMessages() {
        
        if let first = messages.first {
            isAppendHistory = true
            UBCSocketIOManager.sharedInstance.updateHistory(from: first.sentDate)
        }
    }
    
    private func itemNavButton() -> UIBarButtonItem? {
        
        guard let item = currentItem,
            needShowItem(item: item) else { return nil }
        
        let button = UBButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.cornerRadius = 5
        button.addTarget(self, action: #selector(showItem), for: .touchUpInside)
        
        let itemIconURL = URL(string: item.imageURL ?? "")
        button.sd_internalSetImage(with: itemIconURL,
                                   placeholderImage: UIImage(named: "item_default_image"),
                                   options: [],
                                   operationKey: nil,
                                   setImageBlock: nil,
                                   progress: nil,
                                   completed: nil)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        container.addSubview(button)
        
        return UIBarButtonItem(customView: container)
    }
    
    private func needShowItem(item: UBCGoodDM) -> Bool {
        
        if item.isMyItem {
            return true
        } else if item.status == UBCItemStatusActive {
            return true
        } else if let dealArray = item.deals,
                  let deal = dealArray.first,
        let me = UBCUserDM.loadProfile(),
            deal.buyer.id == me.id,
            item.status != UBCItemStatusDeactivated,
            item.status != UBCItemStatusBlocked,
            item.status != UBCItemStatusCheck,
            item.status != UBCItemStatusChecking {
            return true
        }
        
        return false
    }
    
    @objc private func showItem() {
        
        guard let item = currentItem else { return }
        
        if let controller = UBCGoodDetailsController(good: item) {
            self.navigationController?.pushViewController(controller, animated: true)
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
