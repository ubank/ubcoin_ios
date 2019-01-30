//
//  UBCSellerView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11/14/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

@objc
protocol UBCSellerViewDelegate: class {
    func show(seller: UBCSellerDM)
    func chat(seller: UBCSellerDM)
}

class UBCSellerView: UIView {

    @IBOutlet weak var delegate: UBCSellerViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: HUBLabel!
    @IBOutlet weak var rating: UBCStarsView!
    @IBOutlet weak var desc: HUBLabel!
    @IBOutlet weak var chatButton: HUBGeneralButton!
    
    private var seller: UBCSellerDM?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UBCSellerView", owner: self, options: nil)
        addSubview(contentView)
        self.addConstraints(toFillSubview: contentView)
        
        chatButton.addTopSeparator()
        chatButton.titleLabel?.font = UBFont.buttonFont
        avatar.cornerRadius = avatar.height / 2;
    }
    
    @objc func setup(seller: UBCSellerDM?) {
        self.seller = seller
        
        guard let seller = seller else { return }
        
        avatar.sd_setImage(with: URL(string: seller.avatarURL ?? ""),
                           placeholderImage: UIImage(named: "def_prof"),
                           options: [],
                           completed: nil)
        name.text = seller.name
        rating.showStars(seller.rating.uintValue)
        
        desc.text = String(format: "%lu items", seller.itemsCount)
    }
    
    @IBAction func showSeller() {
        if let seller = seller {
            delegate?.show(seller: seller)
        }
    }
    
    @IBAction func showChat() {
        if let seller = seller {
            delegate?.chat(seller: seller)
        }
    }
}
