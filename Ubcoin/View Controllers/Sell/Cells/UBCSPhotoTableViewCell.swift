//
//  UBCSPhotoTableViewCell.swift
//  Ubcoin
//
//  Created by Aidar on 07/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

protocol UBCSPhotoTableViewCellDelegate {
    func addPhoto(_ index: Int?, sender: UIView)
    func deletePhoto(_ index: Int?, sender: UIView)
}


class UBCSPhotoTableViewCell: UBTableViewCell {
    
    static let className = String(describing: UBCSPhotoTableViewCell.self)
    
    var delegate: UBCSPhotoTableViewCellDelegate?
    
    var indexHighlited: Int = 0 {
        didSet {
            for i in 0..<UBCSPhotoTableViewCell.photosCount {
                let view = photoViews[i]
                view.isViewHighlighted = indexHighlited == i
            }
        }
    }
    
    var isDeleteHidden = false {
        didSet {
            for view in self.photoViews {
                view.isDeleteHidden = self.isDeleteHidden
            }
        }
    }
    
    private static let photosCount = 4
    
    private var stackView: UIStackView!
    private var photoViews = [UBCSPhotoAddView]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        self.stackView.distribution = .equalSpacing
        self.contentView.addSubview(self.stackView)
        self.contentView.setTopConstraintToSubview(self.stackView, withValue: 10)
        self.contentView.setBottomConstraintToSubview(self.stackView, withValue: -10)
        self.contentView.setCenterXConstraintToSubview(self.stackView)
        
        for i in 0..<UBCSPhotoTableViewCell.photosCount {
            let photoView = UBCSPhotoAddView(frame: .zero)
            photoView.tag = i
            photoView.delegate = self
            photoViews.append(photoView)
            self.stackView.addArrangedSubview(photoView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let freeSpacing = self.width - 2 * UBCConstant.inset - UBCSPhotoAddView.photosSize * CGFloat(UBCSPhotoTableViewCell.photosCount)
        self.stackView.spacing = freeSpacing / (CGFloat(UBCSPhotoTableViewCell.photosCount) - 1)
    }
}


extension UBCSPhotoTableViewCell: UBCSPhotoAddViewDelegate {
    
    func addPhoto(_ index: Int?, sender: UIView) {
        self.delegate?.addPhoto(index, sender: sender)
    }
    
    func deletePhoto(_ index: Int?, sender: UIView) {
        self.delegate?.deletePhoto(index, sender: sender)
    }
}


extension UBCSPhotoTableViewCell: UBCSellCellProtocol {
    
    func setContent(content: UBCSellCellDM) {
        for i in 0..<UBCSPhotoTableViewCell.photosCount {
            let view = photoViews[i]
            
            view.setBackgroundImage(nil, for: .normal)
            content.imageForIndex(index: i) { image in
                view.setBackgroundImage(image, for: .normal)
            }
        }
    }
}



protocol UBCSPhotoAddViewDelegate: class {
    func addPhoto(_ index: Int?, sender: UIView)
    func deletePhoto(_ index: Int?, sender: UIView)
}

private class UBCSPhotoAddView: UBButton {
    
    weak var delegate: UBCSPhotoAddViewDelegate?
    
    static let photosSize: CGFloat = 70
    
    private lazy var deleteButton: UBButton = { [weak self] in
        let button = UBButton()
        
        button.image = UIImage(named: "icEd")
        button.addTarget(self, action: #selector(deletePressed(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var isViewHighlighted = false {
        didSet {
            self.layer.borderWidth = self.isViewHighlighted ? 2 : 0
        }
    }
    
    var isDeleteHidden = false {
        didSet {
            self.deleteButton.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius = UBCConstant.cornerRadius
        self.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        self.layer.borderColor = UBCColor.green.cgColor
        
        let constraint1 = self.setHeightConstraintWithValue(UBCSPhotoAddView.photosSize)
        constraint1?.priority = UILayoutPriority(999)
        
        let constraint2 = self.setWidthConstraintWithValue(UBCSPhotoAddView.photosSize)
        constraint2?.priority = UILayoutPriority(999)
        
        self.addTarget(self, action: #selector(photoPressed(sender:)), for: .touchUpInside)
        
        self.addSubview(self.deleteButton)
        self.setTopConstraintToSubview(self.deleteButton, withValue: 5)
        self.setTrailingConstraintToSubview(self.deleteButton, withValue: -5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        super.setBackgroundImage(image, for: state)
        
        self.image = image == nil ? UIImage(named: "general_photo") : nil
        self.deleteButton.isHidden = image == nil || self.isDeleteHidden
    }
    
    @objc
    private func photoPressed(sender: UBCSPhotoAddView) {
        let value = sender.backgroundImage(for: .normal) != nil ? self.tag : nil
        self.delegate?.addPhoto(value, sender: sender)
    }
    
    @objc
    private func deletePressed(sender: UBCSPhotoAddView) {
        self.delegate?.deletePhoto(self.tag, sender: sender)
    }
}
