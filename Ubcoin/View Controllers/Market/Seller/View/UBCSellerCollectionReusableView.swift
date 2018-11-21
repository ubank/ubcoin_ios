//
//  UBCSellerCollectionReusableView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11/19/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSellerCollectionReusableView: UICollectionReusableView {

    @objc static let className = String(describing: UBCSellerCollectionReusableView.self)
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: HUBLabel!
    @IBOutlet weak var location: HUBLabel!
    @IBOutlet weak var age: HUBLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.cornerRadius = avatar.height / 2;
    }
    
    func setup(seller: UBCSellerDM?) {
        guard let seller = seller else { return }
        
        avatar.sd_setImage(with: URL(string: seller.avatarURL ?? ""),
                           placeholderImage: UIImage(named: "def_prof"),
                           options: [],
                           completed: nil)
        name.text = seller.name
        location.text = seller.locationText
        age.text = ageText(registrationDate: seller.creationDate)
    }
    
    func ageText(registrationDate: Date?) -> String {
        guard let registrationDate = registrationDate else { return "" }
        
        let days = (registrationDate as NSDate).days(before: Date())
        if days < 30 {
            return String(format: "%@: %lu days", "str_on_market".localizedString(), days)
        } else if days < 365 {
            let months = days / 30
            return String(format: "%@: %lu months", "str_on_market".localizedString(), months)
        } else {
            let years = days / 365
            return String(format: "%@: %lu years", "str_on_market".localizedString(), years)
        }
    }
}
