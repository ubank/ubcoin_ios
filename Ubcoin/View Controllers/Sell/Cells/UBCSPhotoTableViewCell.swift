//
//  UBCSPhotoTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

protocol UBCSPhotoTableViewCellDelegate {
    func addPhotoPressed(_ index: Int, sender: UIView)
}


class UBCSPhotoTableViewCell: UBTableViewCell {
    
    static let className = String(describing: UBCSPhotoTableViewCell.self)
    
    var delegate: UBCSPhotoTableViewCellDelegate?
    
    private var stackView: UIStackView!
    private var photoViews = [UBCSPhotoAddView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.showHighlighted = false
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.stackView = UIStackView()
        self.stackView.axis = .horizontal
        self.stackView.spacing = 10
        self.stackView.distribution = .equalSpacing
        self.contentView.addSubview(self.stackView)
        self.contentView.setTopConstraintToSubview(self.stackView, withValue: 10)
        self.contentView.setBottomConstraintToSubview(self.stackView, withValue: -10)
        self.contentView.setCenterXConstraintToSubview(self.stackView)
        
        for i in 0..<4 {
            let photoView = UBCSPhotoAddView(frame: .zero)
            photoView.tag = i
            photoView.addTarget(self, action: #selector(photoPressed(sender:)), for: .touchUpInside)
            photoViews.append(photoView)
            self.stackView.addArrangedSubview(photoView)
        }
    }
    
    @objc private func photoPressed(sender: UBCSPhotoAddView) {
        if let delegate = self.delegate {
            delegate.addPhotoPressed(sender.tag, sender: sender)
        }
    }
}


extension UBCSPhotoTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        let images = content.data as? [UIImage]
        
        for i in 0..<4 {
            let view = photoViews[i]
            
            var image: UIImage?
            if let images = images, i < images.count {
                image = images[i]
            }
            view.setBackgroundImage(image, for: .normal)
        }
    }
}


private class UBCSPhotoAddView: UBButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = UBCConstant.cornerRadius
        self.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        
        let constraint1 = self.setHeightConstraintWithValue(70)
        constraint1?.priority = UILayoutPriority.init(999)
        
        let constraint2 = self.setWidthConstraintWithValue(70)
        constraint2?.priority = UILayoutPriority.init(999)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        super.setBackgroundImage(image, for: state)
        
        self.image = image == nil ? UIImage(named: "general_photo") : nil
        self.isUserInteractionEnabled = image == nil
    }
}
