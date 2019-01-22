//
//  UBCChatController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCChatController.h"

@interface UBCChatController ()

@property (strong, nonatomic) UBCGoodDM *item;
@property (strong, nonatomic) UBCDealDM *deal;

@end

@implementation UBCChatController

- (instancetype)initWithItem:(UBCGoodDM *)item
{
    self = [super init];
    if (self)
    {
        self.item = item;
    }
    return self;
}

- (instancetype)initWithDeal:(UBCDealDM *)deal
{
    self = [super init];
    if (self)
    {
        self.deal = deal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_chat";
    
    [self updateInfo];
}

- (void)updateInfo
{
    [self startActivityIndicatorImmediately];
    if (self.item)
    {
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider dealForItemID:self.item.ID
                                  withCompletionBlock:^(BOOL success, UBCDealDM *deal)
         {
             
             [weakSelf handleResponseWithDeal:deal];
         }];
    }
    else if (self.deal)
    {
        [self handleResponseWithDeal:self.deal];
    }
}

#pragma mark -

- (void)handleResponseWithDeal:(UBCDealDM *)deal
{
    [self stopActivityIndicator];
}

@end
