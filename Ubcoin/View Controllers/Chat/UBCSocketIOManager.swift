//
//  UBCSocketIOManager.swift
//  Ubcoin
//
//  Created by vkrotin on 18.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import SocketIO
import MessageKit


public enum UBTypeIOMessage : String{
    case textType = "message", imageType = "image"
}

//MARK: Initialize

class UBCSocketIOManager: NSObject {
    
    static let sPath = "https://qa.ubcoin.io"
    static let manager = SocketManager(socketURL: URL(string: sPath)!, config: [.log(false), .compress])
    static let socket = manager.defaultSocket
    //private static var user = UBCUserDM.loadProfile()
    
    private let defaultDate = "2019-01-31T12:26:25.064Z"
    private var completionMessage: ((UBCMessageChat) -> Void)?
    private var completionHistory: (([UBCMessageChat]) -> Void)?
    
  //  private let currentSender = Sender(id: user?.id ?? "0001", displayName: user?.email ?? "Me")
    
    
    @objc class var sharedInstance: UBCSocketIOManager {
        struct Singleton {
            static let instance = UBCSocketIOManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        listenMethods()
    }

    func enterRoom(_ item:UBCGoodDM?) {
        
        guard let item = item,
            let user = UBCUserDM.loadProfile() else {
            return
        }
        
        var params:[String:Any] = [:]
        params["token"] = UBCKeyChain.authorization
        params["itemId"] = item.id
        params["users"] = [user.id, item.seller.id]
        
        UBCSocketIOManager.socket.emit("enterRoom", params)
    }
    
    func enterRoom(_ chatRoom: UBCChatRoom?) {
        guard let chatRoom = chatRoom,
            let user = UBCUserDM.loadProfile() else {
                return
        }
        
        var params:[String:Any] = [:]
        params["token"] = UBCKeyChain.authorization
        params["itemId"] = chatRoom.item.id
        params["users"] = [user.id, chatRoom.user.id]
        
        UBCSocketIOManager.socket.emit("enterRoom", params)
    }
    
    func enterRoom(_ deal: UBCDealDM?) {
        guard let deal = deal else {
                return
        }
        
        var params:[String:Any] = [:]
        params["token"] = UBCKeyChain.authorization
        params["itemId"] = deal.item.id
        params["users"] = [deal.seller.id, deal.buyer.id]
        
        UBCSocketIOManager.socket.emit("enterRoom", params)
    }
}

//MARK: Sender methods

extension UBCSocketIOManager {
    
    func sendPhoto(_ image:UIImage) {
        
        UBCDataProvider.shared.uploadImage(image, withCompletionBlock: {[weak self] isCompite, imageUrl in
            if let imageUrl = imageUrl, isCompite == true {
                self?.sendMessage(message: imageUrl, .imageType)
            
            }
        })
    }
    
    func sendMessage(message: String, _ type: UBTypeIOMessage = .textType) {
        var params:[String:Any] = [:]
        params["content"] = message
        params["type"] = type.rawValue

        if let userDM = UBCUserDM.loadProfile() {
            params["publisher"] =  userDM.id
        }
        UBCSocketIOManager.socket.emit("sendMessage", params)
    }
    
    func exitChat() {
        UBCSocketIOManager.socket.emit("leaveRoom")
    }
    
    func updateHistory(from date:Date?, limit:Int = 15) {
        guard let date = date else {
            return
        }
        let st = date.chatStringDate()
        UBCSocketIOManager.socket.emit("history", ["fromDate":st ?? defaultDate, "limit":limit])
    }
    
    func updatePushMessage(_ messageId: String?, _ senderId: String?) {
        guard let messageId = messageId, let userDM = UBCUserDM.loadProfile(), senderId != userDM.id  else {
            return
        }
        UBCSocketIOManager.socket.emit("messageRead", ["messageId" : messageId])
    }
}

//MARK: Listener methods

extension UBCSocketIOManager {
    
    func messageListener(_ completion: ((UBCMessageChat) -> Void)?) {
        completionMessage = completion
    }
    
    func historyListener(_ completion: (([UBCMessageChat]) -> Void)?) {
        completionHistory = completion
    }
    
    private func listenMethods() {
        
        UBCSocketIOManager.socket.on("history") {[weak self] dataArray, socketAck in
            guard let sself = self else {
                return
            }
            if let data = dataArray[0] as? [[String:Any]], let completion = sself.completionHistory {
                var obj = data.map{UBCMessageChat(history: $0)}.compactMap { $0 }
                obj.reverse()
                
                completion(obj)
            }
        }
        
        UBCSocketIOManager.socket.on("sendMessage") { [weak self] dataArray, socketAck in
            guard let sself = self else {
                return
            }
            if let data = dataArray[0] as? [String:Any], let completion = sself.completionMessage {
                
                guard let mess =  UBCMessageChat(data) else {
                    sself.updateHistory(from: Date())
                    return
                }
                
                sself.updatePushMessage(mess.messageId, mess.sender.id)
                completion(mess)
            }
        }
    }
    
}

//MARK: Connect\Disconnect

extension UBCSocketIOManager {
    
    @objc func establishConnection() {
        UBCSocketIOManager.socket.connect()
    }
    
    @objc func closeConnection() {
        UBCSocketIOManager.socket.disconnect()
    }
    
    @objc func reloadConnection() {
        UBCSocketIOManager.socket.disconnect()
        UBCSocketIOManager.socket.connect()
    }
}
