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
    
    let refreshControl = UIRefreshControl()
    var messages: [UBCMessageChat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureMessageInputBar()
        configureMessageCollectionView()
        configureCamera()
    }
    
    override var title: String? {
        didSet{
            navigationItem.title = title
            tabBarController?.navigationItem.title = title
            navigationController?.title = title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imgBack = UIImage(named: IMG_NAVBAR_BACK)
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UBColor.navigationTintColor!
        navigationController?.navigationBar.barTintColor = UBColor.backgroundColor!
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UBColor.navigationTitleColor!]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.view.backgroundColor = UBColor.backgroundColor!
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
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
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        // 3
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
        
        present(picker, animated: true, completion: nil)
    }
        
    
    // MARK: - Helpers
    
    func setHistory(_ messages: [UBCMessageChat]) {
        self.messages = messages
        
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
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
        case .text(_):
            print("text")
        case .attributedText(_):
            print("attr")
        case .photo(let photoItem):
            if let ubcItem = photoItem as? UBCMediaItem {
                
                imageView.sd_setImage(with: ubcItem.url, completed: nil)
                
//                ubcItem.loadImage({[weak self] image in
//                    self?.reloadInputViews()
//                    imageView.image = image
//                })
            }
            print("photp")
        case .video(_):
            print("video")
        case .location(_):
            print("location")
        case .emoji(_):
            print("emoj")
        case .custom(_):
            print("custom")
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
            picker.dismiss(animated: true, completion: nil)
            
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
