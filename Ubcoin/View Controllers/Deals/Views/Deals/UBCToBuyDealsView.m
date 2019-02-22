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
        [self.tableView.refreshControll beginRefreshing];
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider dealsToBuyWithCompletionBlock:^(BOOL success, NSArray *itemsSections)
         {
             [weakSelf handleResponse:itemsSections];
         }];
    }
    else
    {
        self.tableView.emptyView.hidden = NO;
    }
}

#pragma mark - UBDefaultTableViewDelegate

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCGoodDM *item = data.data;
    
    UBCDealCell *dealCell = (UBCDealCell *)cell;
    dealCell.info.attributedText = item.seller.info;
    [dealCell setLocation:item.location];
}

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(showItem:)])
    {
        UBCGoodDM *item = data.data;
        [self.delegate showItem:item];
    }
}

@end
