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

let sPath = "https://qa.ubcoin.io"
let manager = SocketManager(socketURL: URL(string: sPath)!, config: [.log(true), .compress])
let socket = manager.defaultSocket
private let user = UBCUserDM.loadProfile()

public enum UBTypeIOMessage : String{
    case textType = "message", imageType = "image"
}

//MARK: Initialize

class UBCSocketIOManager: NSObject {
    
    private let defaultDate = "2019-01-31T12:26:25.064Z"
    private var completionMessage: ((UBCMessageChat) -> Void)?
    private var completionHistory: (([UBCMessageChat]) -> Void)?
    
    let currentSender = Sender(id: user?.id ?? "0001", displayName: user?.email ?? "Me")
    
    
    @objc class var sharedInstance: UBCSocketIOManager {
        struct Singleton {
            static let instance = UBCSocketIOManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }

    func enterRoom(item:UBCGoodDM?) {
        
        guard let item = item,
              let user = user else {
            return
        }
        
        
        listenMethods()
        
        var params:[String:Any] = [:]
        params["token"] = UBCKeyChain.authorization
        params["itemId"] = item.id
        params["users"] = [user.id, item.seller.id]
        
        socket.emit("enterRoom", params)
    }
}

//MARK: Sender methods

extension UBCSocketIOManager {
    
    func sendPhoto(_ image:UIImage) {
        UBCDataProvider.shared.uploadImage(image, withCompletionBlock: { isCompite, imageUrl in
            if let imageUrl = imageUrl, isCompite == true {
                DispatchQueue.main.async { [weak self] in
                    self?.sendMessage(message: imageUrl, .imageType)
                }
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
        socket.emit("sendMessage", params)
        
        if type == .imageType {
            updateHistory(from: Date())
        }
    }
    
    func exitChat() {
        socket.emit("leaveRoom")
    }
    
    func updateHistory(from date:Date?, limit:Int = 50) {
        guard let date = date else {
            return
        }
        let st = date.chatStringDate()
        //NSDate.stringFromDate(inFormat_dd_MM_yyyy_HH_mm_ss: date)
        socket.emit("history", ["fromDate":st ?? defaultDate, "limit":limit])
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
        
        socket.on("history") {[weak self] dataArray, socketAck in
            guard let sself = self else {
                return
            }
            if let data = dataArray[0] as? [[String:Any]], let completion = sself.completionHistory {
                var obj = data.map{UBCMessageChat(history: $0)}.compactMap { $0 }
                obj.reverse()
                
                completion(obj)
            }
        }
        
        socket.on("sendMessage") { [weak self] dataArray, socketAck in
            guard let sself = self else {
                return
            }
            if let data = dataArray[0] as? [String:Any], let completion = sself.completionMessage {
                
                guard let mess =  UBCMessageChat(data) else {
                    sself.updateHistory(from: Date())
                    return
                }
                completion(mess)
            }
        }
    }
    
}

//MARK: Connect\Disconnect

extension UBCSocketIOManager {
    
    @objc func establishConnection() {
        socket.connect()
    }
    
    @objc func closeConnection() {
        socket.disconnect()
    }
}

extension Date {
    
    func chatStringDate() -> String? {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
    
    func chatDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func chatDate() -> Date? {
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
        
      //  dateFormater.locale = UBLocal.shared.locale;
      //  dateFormater.timeZone = NSTimeZone.systemTimeZone
    }
}

extension UIColor {
    static let primaryMessage = UIColor(hexString: "279A75")!
    static let slaveMessage = UIColor(hexString: "BFBFBF")!
}
