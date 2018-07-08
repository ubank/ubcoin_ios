//
//  UBCDiscountCell.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISCOUNT_CELL_HEIGHT 160

@class UBCDiscountDM;
@interface UBCDiscountCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UBCDiscountDM *content;

@end
