//
//  UBCGoodCell.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLLECTION_CELL_HEIGHT 220

@class UBCGoodDM;
@interface UBCGoodCell : UICollectionViewCell

@property (strong, nonatomic) UBCGoodDM *content;

@end
