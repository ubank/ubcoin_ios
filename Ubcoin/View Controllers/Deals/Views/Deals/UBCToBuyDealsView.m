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

#import "Ubcoin-Swift.h"

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
    UBCDealDM *deal = data.data;

    UBCDealCell *dealCell = (UBCDealCell *)cell;
    dealCell.info.text = deal.statusDescription;
    [dealCell setLocation:deal.item.location];
    
    dealCell.badgeView.hidden =  ![UBCNotificationDM isContainsDeal:deal.ID];
    
    if (data.isDisabled)
    {
        cell.title.textColor = UBColor.descColor;
        cell.desc.textColor = UBColor.descColor;
    }
    else
    {
        cell.title.textColor = UBColor.titleColor;
        cell.desc.textColor = UBColor.titleColor;
    }
}

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(showDeal:)])
    {
        UBCDealDM *deal = data.data;
         [UBCNotificationDM removeSaveDeal:deal.ID];
        
        [self.delegate showDeal:deal];
    }
}

@end
