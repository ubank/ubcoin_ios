//
//  UBCToBuyDealsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCToBuyDealsView.h"
#import "UBCKeyChain.h"
#import "UBCDealCell.h"

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

#pragma mark - UBDefaultTableViewDelegate

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCDealDM *deal = data.data;
    
    UBCDealCell *dealCell = (UBCDealCell *)cell;
    dealCell.info.attributedText = deal.seller.info;
    [dealCell setLocation:deal.item.location];
}

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(showDeal:)])
    {    
        UBCDealDM *deal = data.data;
        [self.delegate showDeal:deal];
    }
}

@end
