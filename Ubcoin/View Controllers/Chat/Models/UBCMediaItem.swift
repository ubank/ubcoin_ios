//
//  UBCMediaItem.swift
//  Ubcoin
//
//  Created by vkrotin on 20.02.2019.
//  Copyright © 2019 UBANK. All rights reserved.
//

import UIKit
import MessageKit


class UBCMediaItem: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    

    init(_ url: URL?, placeholder:UIImage? = nil) {
        self.url = url
        self.image = nil
        self.placeholderImage = UIImage()
        self.size = CGSize(width: 200, height: 200)
    }

}
