//
//  UBCChatController.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBViewController.h"
#import "UBCGoodDM.h"
#import "UBCDealDM.h"

@interface UBCChatController : UBViewController

- (instancetype)initWithItem:(UBCGoodDM *)item;
- (instancetype)initWithDeal:(UBCDealDM *)deal;
- (instancetype)initWithURL:(NSURL *)url appURL:(NSURL *)appURL;

@end
