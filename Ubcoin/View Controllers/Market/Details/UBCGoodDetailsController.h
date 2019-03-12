//
//  UBCGoodDetailsController.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBViewController.h"

@class UBCGoodDM;
@interface UBCGoodDetailsController : UBViewController

- (instancetype)initWithGood:(UBCGoodDM *)good;
- (instancetype)initWithGoodID:(NSString *)goodID;
- (instancetype)initWithGood:(UBCGoodDM *)good andDeal:(BOOL) isDeal;

@end
