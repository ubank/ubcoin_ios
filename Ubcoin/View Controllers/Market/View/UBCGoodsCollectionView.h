//
//  UBCGoodsCollectionView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBCGoodDM.h"
#import "UBCDiscountsCollectionView.h"

@protocol UBCGoodsCollectionViewDelegate

- (void)didSelectDiscount:(UBCDiscountDM *)discount;
- (void)didSelectItem:(UBCGoodDM *)item;
- (void)refreshControlUpdate;
- (void)updatePagination;

@end

@interface UBCGoodsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UBCDiscountsCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet id<UBCGoodsCollectionViewDelegate> actionsDelegate;
@property (strong, nonatomic) NSArray<UBCGoodDM *> *items;
@property (strong, nonatomic) NSArray<UBCDiscountDM *> *discounts;
@property (assign, nonatomic) BOOL canLoadMore;

@end
