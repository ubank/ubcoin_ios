//
//  UBCImageSource.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11/14/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import ImageSlideshow

class UBCImageSource: NSObject, InputSource {
    
    var url: URL
    var placeholder: UIImage?
    
    @objc
    init?(urlString: String, placeholder: UIImage? = nil) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.placeholder = placeholder
            super.init()
        } else {
            return nil
        }
    }
    
    func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.sd_setImage(with: self.url, placeholderImage: self.placeholder, options: [], completed: { (image, _, _, _) in
            callback(image)
        })
    }
    
    func cancelLoad(on imageView: UIImageView) {
        imageView.sd_cancelCurrentImageLoad()
    }
}
