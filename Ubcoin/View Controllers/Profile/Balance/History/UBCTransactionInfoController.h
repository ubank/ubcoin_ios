//
//  UBCTransactionInfoController.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 17.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBViewController.h"

@class UBCTransactionDM;
@interface UBCTransactionInfoController : UBViewController

- (instancetype)initWithTransaction:(UBCTransactionDM *)transaction;

@end
