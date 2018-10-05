//
//  UBCFiltersView.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 10/4/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCFiltersView: UIView {

    var filters = [String]()
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UBCFilterCollectionViewCell.self, forCellWithReuseIdentifier: UBCFilterCollectionViewCell.className)
        
        return collectionView
    }()
    
    convenience init() {
        self.init()
        
        setupCollectionView()
    }

    private func setupCollectionView() {
        self.addSubview(collectionView)
        self.addConstraints(toFillSubview: collectionView)
    }
}

extension UBCFiltersView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize.init(width: 50, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
