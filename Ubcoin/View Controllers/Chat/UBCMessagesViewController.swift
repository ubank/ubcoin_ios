//
//  UBCMessagesViewController.swift
//  Ubcoin
//
//  Created by vkrotin on 20.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Photos

class UBCMessagesViewController: MessagesViewController {
    
    private var isImagePicker = false
    
    let refreshControl = UIRefreshControl()
    var messages: [UBCMessageChat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        configureMessageCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isImagePicker == false {
           UBCSocketIOManager.sharedInstance.exitChat()
        }
        
        navigationController?.navigationBar.clearShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imgBack = UIImage(named: IMG_NAVBAR_BACK)
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UBColor.navigationTintColor!
        navigationController?.navigationBar.barTintColor = UBColor.backgroundColor!
        navigationController?.navigationBar.defaultShadow()
        
        navigationController?.view.backgroundColor = UBColor.backgroundColor!
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: Configure Message
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.backgroundColor = UBColor.backgroundColor
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = UBColor.navigationTintColor
        messageInputBar.sendButton.tintColor = UBColor.navigationTintColor
        
       // messageInputBar.isTranslucent = true
       // messageInputBar.separatorLine.isHidden = true
        
        messageInputBar.separatorLine.backgroundColor = UIColor(hexString: "F5F5F5")
        messageInputBar.separatorLine.defaultShadow()
        
        messageInputBar.inputTextView.backgroundColor = UIColor(hexString: "F5F5F5")
        messageInputBar.inputTextView.placeholderTextColor = UIColor(hexString: "9A9A9A")
        messageInputBar.inputTextView.placeholder =  "New message..."
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(hexString: "D7DFE1")?.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.setImage(#imageLiteral(resourceName: "chat_send_message"), for: .normal)
        messageInputBar.sendButton.setTitle(nil, for: .normal)
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.textViewPadding.right = -38
 

        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = .primaryMessage
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                })
        }
        
        configureCamera()
    }
    
    func configureCamera() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .primaryMessage
        cameraItem.setImage(#imageLiteral(resourceName: "general_photo"), for: .normal)
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .touchUpInside
        )
        cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
        cameraItem.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
    
    @objc func loadMoreMessages() {
    }
    
    
    // MARK: - Actions
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        isImagePicker = true
        present(picker, animated: true, completion: nil)
    }
        
    
    // MARK: - Helpers
    
    func setHistory(_ messages: [UBCMessageChat], append:Bool = false) {
        
        if append == true {
            self.messages.insert(contentsOf: messages, at: 0)
        } else{
            self.messages = messages
        }
        
        DispatchQueue.main.async { [weak self] in
            if append == true {
                if messages.count != 1 {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
               
            } else {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToBottom(animated: false)
            }
            
        }
    }
    
    func insertMessage(_ message: UBCMessageChat) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

}

// MARK: - MessagesLayoutDelegate

extension UBCMessagesViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        }
        
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate) {
            return -10
        }
        return 50
    }
    
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 20
//    }
//
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
//
}

// MARK: - MessagesDisplayDelegate

extension UBCMessagesViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primaryMessage : .slaveMessage
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
        
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let photoItem):
            if let ubcItem = photoItem as? UBCMediaItem {
                imageView.sd_setImage(with: ubcItem.url, completed: nil)
            }
        default:
            break
        }
    }
}

// MARK: - MessagesDataSource

extension UBCMessagesViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return UBCSocketIOManager.sharedInstance.currentSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate) {
            return nil
        }
        
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//    }
//
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let dateString = message.sentDate.chatDisplayDate()
//        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
//    }
    
}

// MARK: - MessageInputBarDelegate

extension UBCMessagesViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        UBCSocketIOManager.sharedInstance.sendMessage(message: text)
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}


    // MARK: - UIImagePickerControllerDelegate
    
    extension UBCMessagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            picker.dismiss(animated: true, completion: { [weak self] in
                self?.isImagePicker = false
            })
            
            if let asset = info[UIImagePickerControllerEditedImage] as? PHAsset {
                let size = CGSize(width: 250, height: 250)
                PHImageManager.default().requestImage(
                    for: asset,
                    targetSize: size,
                    contentMode: .aspectFit,
                    options: nil) { result, info in
                        guard let image = result else {
                            return
                        }
                        UBCSocketIOManager.sharedInstance.sendPhoto(image)
                }
            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UBCSocketIOManager.sharedInstance.sendPhoto(image)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
}
