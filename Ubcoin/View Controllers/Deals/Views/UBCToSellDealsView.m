//
//  UBCToSellDealsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCToSellDealsView.h"
#import "UBCKeyChain.h"
#import "UBCDealCell.h"

@implementation UBCToSellDealsView

- (void)setupEmptyView
{
    [super setupEmptyView];
    
    self.tableView.emptyView.desc.text = UBLocalizedString(@"str_items_to_sell_will_be_here", nil);
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
    [UBCDataProvider.sharedProvider dealsToSellListWithPageNumber:self.pageNumber
                                              withCompletionBlock:^(BOOL success, NSArray *items, BOOL canLoadMore)
     {
         if (success)
         {
             weakSelf.tableView.canLoadMore = canLoadMore;
         }
         [weakSelf handleResponse:items];
     }];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCGoodDM *item = data.data;
    
    UBCDealCell *dealCell = (UBCDealCell *)cell;
//    dealCell.info.attributedText = [self infoStringWithString:deal.buyer.name];
    [dealCell setLocation:item.location];
}

@end
