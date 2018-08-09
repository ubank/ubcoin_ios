//
//  UBCToBuyDealsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCToBuyDealsView.h"
#import "UBCKeyChain.h"

@implementation UBCToBuyDealsView

- (void)setupEmptyView
{
    [super setupEmptyView];
    
    self.tableView.emptyView.desc.text = UBLocalizedString(@"str_items_to_buy_will_be_here", nil);
}

- (void)updateInfo
{
    if (UBCKeyChain.authorization)
    {
        if (self.items.count == 0)
        {
            [self.tableView.refreshControll beginRefreshing];
        }
        [self loadDeals];
    }
    else
    {
        self.tableView.emptyView.hidden = NO;
    }
}

#pragma mark -

- (void)loadDeals
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider dealsToBuyListWithPageNumber:self.pageNumber
                                             withCompletionBlock:^(BOOL success, NSArray *deals, BOOL canLoadMore)
     {
         if (success)
         {
             weakSelf.tableView.canLoadMore = canLoadMore;
         }
         [weakSelf handleResponse:deals];
     }];
}

@end
