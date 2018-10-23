//
//  UBCFilterValueSelectionCell.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/18/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

protocol UBCFilterValueSelectionCellDelegate: AnyObject {
    func didSelect()
}

class UBCFilterValueSelectionCell: UBDefaultTableViewCell {

    static let className = NSStringFromClass(UBCFilterValueSelectionCell.self)

    weak var delegate: UBCFilterValueSelectionCellDelegate?
    private var filters = [UBTableViewRowData]()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setHeightConstraintWithValue(35)
        
        collectionView.register(UINib(nibName: UBCFilterTitleCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: UBCFilterTitleCollectionViewCell.className)
        
        return collectionView
    }()
    
    private lazy var sizingCell: UBCFilterTitleCollectionViewCell = {
        guard let cell = UBCFilterTitleCollectionViewCell.loadFromXib() else {
            preconditionFailure("Failed to load cell from XIB")
        }
        
        return cell
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftStackView.addArrangedSubview(collectionView)
        leftIndent = 0
        rightIndent = 0
        
        desc.font = UBFont.titleFont
        desc.leftInset = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var rowData: UBTableViewRowData? {
        didSet {
            let param = rowData?.data as? UBCFilterParam
            filters = param?.values ?? [UBTableViewRowData]()
            collectionView.reloadData()
        }
    }
}

extension UBCFilterValueSelectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let filter = filters[indexPath.row]
        sizingCell.title.text = filter.title
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size = sizingCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        return CGSize(width: size.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UBCFilterTitleCollectionViewCell.className, for: indexPath)
        
        if let cell = cell as? UBCFilterTitleCollectionViewCell {
            let filter = filters[indexPath.row]
            cell.title.text = filter.title
            cell.isSelected = filter.isSelected
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        let param = rowData?.data as? UBCFilterParam
        for row in filters {
            if row.name == filter.name {
                row.isSelected = !row.isSelected
                param?.value = row.isSelected ? filter.name : ""
                param?.title = row.isSelected ? filter.title : ""
            } else {
                row.isSelected = false
            }
        }
        
        collectionView.reloadData()
        
        delegate?.didSelect()
    }
}
