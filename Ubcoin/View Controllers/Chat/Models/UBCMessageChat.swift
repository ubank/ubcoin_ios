//
//  UBCMessageChat.swift
//  Ubcoin
//
//  Created by vkrotin on 19.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import MessageKit

class UBCMessageChat: MessageType {
    
    let id: String?

   
    var content: String = ""
    let sentDate: Date
    let sender: Sender
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let mediaItem = mediaItem {
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var mediaItem: MediaItem? = nil
    var downloadURL: URL? = nil
    
    
    init?(_ document: [String:Any]) {
        guard let sentDate = (document["date"] as? String)?.chatDate(),
            let senderName = document["userName"] as? String,
            let messId = document["id"] as? String else {
                return nil
        }
        
        guard let msgDict = document["msg"] as? [String:String],
            let content = msgDict["content"],
            let type = msgDict["type"],
            let publiser = msgDict["publisher"] else {
            return nil
        }
        
        self.id = messId
        self.sentDate = sentDate
        sender = Sender(id:publiser, displayName: senderName)
        
        if type == "image"{
            mediaItem = UBCMediaItem(URL(string: content))
        } else {
            self.content = content
        }
    }
    
    init?(history document: [String:Any]) {
        
        guard let sentDate = (document["date"] as? String)?.chatDate() else {
            return nil
        }
        guard let senderName = document["userName"] as? String else {
            return nil
            
        }
        
        guard let msgDict = UBCMessageChat.parseJsonString(document["msg"] as! String) ,
            let content = msgDict["content"],
            let type = msgDict["type"],
            let publiser = msgDict["publisher"] else {
                return nil
        }
        
        self.id = nil
        
        self.sentDate = sentDate
        sender = Sender(id:publiser, displayName: senderName)
        
        if type == "image"{
            mediaItem = UBCMediaItem(URL(string: content))
        } else {
            self.content = content
        }
    }
    
    
    static func parseJsonString(_ jsonText:String) -> [String:String]? {
        var dictonary:[String:String]?
        if let data = jsonText.data(using: String.Encoding.utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String]
            } catch let error as NSError {
                print(error)
            }
        }
        return dictonary
    }

}
