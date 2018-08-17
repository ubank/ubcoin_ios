//
//  UBCTransactionInfoController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 17.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTransactionInfoController.h"
#import "UBCTransactionDM.h"

@interface UBCTransactionInfoController ()

@property (strong, nonatomic) UBCTransactionDM *transaction;

@end

@implementation UBCTransactionInfoController

- (instancetype)initWithTransaction:(UBCTransactionDM *)transaction
{
    self = [super init];
    if (self)
    {
        self.transaction = transaction;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

@end
