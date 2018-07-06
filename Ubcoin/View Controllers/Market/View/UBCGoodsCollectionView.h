//
//  UBCGoodsCollectionView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBCGoodDM.h"

@protocol UBCGoodsCollectionViewDelegate

- (void)didSelectItem:(UBCGoodDM *)item;
- (void)refreshControlUpdate;
- (void)updatePagination;

@end

@interface UBCGoodsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet id<UBCGoodsCollectionViewDelegate> actionsDelegate;
@property (strong, nonatomic) NSArray<UBCGoodDM *> *items;
@property (assign, nonatomic) BOOL canLoadMore;

@end
