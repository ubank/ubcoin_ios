//
//  UBCFiltersView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFiltersView: UIView {

    @objc var filtersChanged: (([UBCFilterParam]) -> Void)?
    
    private var filters = [UBCFilterParam]()
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: UBCFilterCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: UBCFilterCollectionViewCell.className)
        
        return collectionView
    }()
    
    private lazy var sizingCell: UBCFilterCollectionViewCell = {
        guard let cell = UBCFilterCollectionViewCell.loadFromXib() else {
            preconditionFailure("Failed to load cell from XIB")
        }
        
        return cell
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        setupCollectionView()
    }

    @objc func update(filters: [UBCFilterParam]) {
        self.filters = filters.filter { !$0.value.isEmpty }
        self.isHidden = self.filters.count == 0
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.addConstraints(toFillSubview: collectionView)
    }
}

extension UBCFiltersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UBCFilterCollectionViewCell.className, for: indexPath)

        if let cell = cell as? UBCFilterCollectionViewCell {        
            let filter = filters[indexPath.row]
            cell.title.text = filter.title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filters.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        self.isHidden = filters.count == 0
        
        if let filtersChanged = self.filtersChanged {
            filtersChanged(filters)
        }
    }
}
