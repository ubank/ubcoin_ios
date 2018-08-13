//
//  UBCDiscountsCollectionView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBCDiscountDM.h"

#define DISCOUNTS_HEIGHT 190

@protocol UBCDiscountsCollectionViewDelegate <NSObject>

- (void)showDiscountInfo:(UBCDiscountDM *)discount;

@end

@interface UBCDiscountsCollectionView : UICollectionReusableView

@property (weak, nonatomic) id<UBCDiscountsCollectionViewDelegate> delegate;
@property (strong, nonatomic) NSArray *discounts;

@end
