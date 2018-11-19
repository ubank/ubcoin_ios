//
//  UBCSellerController.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11/14/18.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCSellerController: UBViewController {

    private lazy var collectionView: UBCGoodsCollectionView = {
        let collectionView = UBCGoodsCollectionView()
        collectionView.actionsDelegate = self
        collectionView.register(UINib(nibName: UBCSellerCollectionReusableView.className, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UBCSellerCollectionReusableView.className)
        
        return collectionView
    }()
    
    private var pageNumber: UInt = 0
    private var items = [UBCGoodDM]()
    private var canLoadMore: Bool = false
    private var seller: UBCSellerDM?
    private var sellerID: String?
    
    @objc
    init(seller: UBCSellerDM) {
        self.seller = seller
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc
    init(sellerID: String?) {
        self.sellerID = sellerID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationContainer.buttonsImageColor = UBColor.navigationTitleColor
        
        view.addSubview(collectionView)
        view.addConstraints(toFillSubview: collectionView)
        
        startActivityIndicatorImmediately()
        if seller == nil {
            loadSellerInfo()
        } else {
            setupContent()
            updateInfo()
        }
    }

    override func updateInfo() {
        guard let seller = seller else { return }
        
        UBCDataProvider.shared.goodsList(withPageNumber: pageNumber, forSeller: seller.id) { [weak self] success, goods, canLoadMore in
            guard let self = self else { return }
            
            if success {
                if self.pageNumber == 0 {
                    self.items = [UBCGoodDM]()
                }
                
                if let goods = goods as? [UBCGoodDM] {
                    self.items.append(contentsOf: goods)
                }
                self.collectionView.canLoadMore = canLoadMore
                self.pageNumber += 1
            }
            
            self.stopActivityIndicator()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.items = self.items
        }
    }
    
    private func loadSellerInfo() {
        guard let sellerID = sellerID else { return }
        
        UBCDataProvider.shared.seller(withID: sellerID) { [weak self] success, seller in
            if let seller = seller {
                self?.seller = seller
                self?.setupContent()
                self?.updateInfo()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setupContent() {
        guard let seller = seller else { return }
        
        title = seller.name
        navigationContainer.rightImageTitle = seller.shareURL.isEmpty ? nil : "general_export"
        updateBarButtons()
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        guard let seller = seller,
            let url = seller.shareURL else { return }
        
        let textToShare = String(format: "%@ on Ubcoin Market %@", seller.name, url)
        shareActivityItems([textToShare], withSubject: "", withSender: sender, withCompletionBlock: nil)
    }
}

extension UBCSellerController: UBCGoodsCollectionViewDelegate {
    
    func didSelectItem(_ item: UBCGoodDM!) {
        guard let controller = UBCGoodDetailsController(good: item) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updatePagination() {
        updateInfo()
    }
    
    func refreshControlUpdate() {
        pageNumber = 0
        if seller == nil {
            loadSellerInfo()
        } else {
            updateInfo()
        }
    }
    
    func referenceSizeForHeader(inSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 100)
    }
    
    func viewForSupplementaryElement(ofKind kind: String!, at indexPath: IndexPath!) -> UICollectionReusableView! {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UBCSellerCollectionReusableView.className, for: indexPath) as? UBCSellerCollectionReusableView {
            headerView.setup(seller: seller)
            
            return headerView
        } else {
            return nil
        }
    }
}
