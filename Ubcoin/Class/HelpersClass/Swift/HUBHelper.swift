//
//  HUBHelper.swift
//  Halva
//
//  Created by Александр Макшов on 09.07.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

import Foundation
import UIKit

@objc
extension UIView {
    
    private static let activityTag = 1005
    
    func topSafeArea() -> CGFloat {
        if #available(iOS 11, *) {
            return self.safeAreaInsets.top
        }
        
        return 20
    }
    
    func defaultShadow() {
        self.layer.shadowColor = UBCColor.shadowColor.cgColor
        self.layer.shadowOpacity = UBCConstant.shadowOpacity
        self.layer.shadowRadius = UBCConstant.shadowRadius
        self.layer.shadowOffset = UBCConstant.shadowOffset
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
    }
    
    func clearShadow()  {
        self.layer.shadowOpacity = 0.0;
    }
}


extension UIButton {
    
    func centerContentVertically() {
        guard let titleLabel = self.titleLabel, let imageView = self.imageView, let buttonTitle = titleLabel.text, let image = imageView.image else { return }
        
        self.contentHorizontalAlignment = .left
        self.contentVerticalAlignment = .top
        
        let titleSize = NSString(string: buttonTitle).size(withAttributes: [.font: titleLabel.font])
        let buttonImageSize = image.size
        
        let topImageOffset = (self.height - (titleSize.height + buttonImageSize.height)) / 2
        let leftImageOffset = (self.width - buttonImageSize.width) / 2
        self.imageEdgeInsets = UIEdgeInsetsMake(topImageOffset, leftImageOffset, 0, 0)
        
        let titleTopOffset = topImageOffset + buttonImageSize.height
        let leftTitleOffset = (self.width - titleSize.width) / 2 - image.size.width
        self.titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset, leftTitleOffset, 0, 0)
    }
}


extension String {
    
    func localizedString() -> String {
        return UBLocal.shared.localizedString(forKey: self, value: nil) ?? ""
    }
}


extension UIDevice {
    
    func isIPad() -> Bool {
        return self.userInterfaceIdiom == .pad
    }
}


extension Optional where Wrapped: Collection {
    
    func unwrap(_ value: Wrapped) -> Wrapped {
        guard let currentValue = self, !currentValue.isEmpty else {
            return value
        }
        
        return currentValue
    }
}


extension Optional {
    
    func unwrap(_ value: Wrapped) -> Wrapped {
        guard let currentValue = self else {
            return value
        }
        
        return currentValue
    }
}


extension UIImageView {
    
    @objc
    func loadFitImage(imageURL: String?) {
        self.loadImage(imageURL: imageURL, needFit: true)
    }
    
    @objc
    func loadFillImage(imageURL: String?) {
        self.loadImage(imageURL: imageURL, needFit: false)
    }
    
    func loadImage(imageURL: String?, needFit: Bool = false) {
        guard var url = imageURL else { return }
        
        let imageWidth = Int(self.width * UIScreen.main.scale)
        let imageHeight = Int(self.height * UIScreen.main.scale)
        
        url = url + "?width=\(imageWidth)&height=\(imageHeight)"
        url = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed) ?? ""
        
        self.sd_setImage(with: URL(string: url)) { [weak self] image, _, _, _ in
            guard let image = image else { return }
            
            self?.image = image
            
            if needFit {
                self?.setupContentModeFit()
            } else {
                self?.setupContentModeFill()
            }
        }
    }
}
