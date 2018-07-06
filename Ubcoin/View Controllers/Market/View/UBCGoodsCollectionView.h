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

@end

@interface UBCGoodsCollectionView : UICollectionView

@property (weak, nonatomic) id<UBCGoodsCollectionViewDelegate> actionsDelegate;

@end
