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

#import "Ubcoin-Swift.h"

@implementation UBCToSellDealsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateInfo)
                                                     name:kNotificationItemChanged
                                                   object:nil];
    }
    
    return self;
}

- (void)setupEmptyView
{
    [super setupEmptyView];
    
    self.tableView.emptyView.desc.text = UBLocalizedString(@"str_items_to_sell_will_be_here", nil);
}

- (void)updateInfo
{
    if (UBCKeyChain.authorization)
    {
        [self.tableView.refreshControll beginRefreshing];
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider dealsToSellWithCompletionBlock:^(BOOL success, NSArray *itemsSections)
         {
             [weakSelf handleResponse:itemsSections];
         }];
    }
    else
    {
        self.tableView.emptyView.hidden = NO;
    }
}

-(void) setIsNeedShowBadge:(BOOL)isNeedShowBadge {
    [super setIsNeedShowBadge:isNeedShowBadge];
    
    UBCNotificationDM.needShowDealItemToSoldBadge = self.isNeedShowBadge;
}

#pragma mark -

- (NSAttributedString *)infoStringWithItem:(UBCGoodDM *)item
{
    switch (item.status)
    {
        case UBCItemStatusBlocked:
            return [NSAttributedString attributedWithString:UBLocalizedString(@"str_item_status_blocked", nil)
                                                       font:UBFont.descFont
                                                      color:RED_COLOR
                                                  alignment:NSTextAlignmentLeft];
        default:
            return [NSAttributedString attributedWithString:[NSString notEmptyString:item.statusDescription]
                                                       font:UBFont.descFont
                                                      color:UBColor.descColor
                                                  alignment:NSTextAlignmentLeft];
    }
}

#pragma mark - UBDefaultTableViewDelegate

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCGoodDM *item = data.data;
    
    UBCDealCell *dealCell = (UBCDealCell *)cell;
    dealCell.info.attributedText = [self infoStringWithItem:item];
    [dealCell setLocation:item.location];
    
    if (item.activePurchase) {
        if (item.activePurchase.needAction == YES) {
            self.isNeedShowBadge = YES;
        }
        
       dealCell.badgeView.hidden =  !item.activePurchase.needAction;
    } else {
        dealCell.badgeView.hidden = true;
    }
    
    [dealCell.contentView setTopConstraintToSubview:dealCell.badgeView withValue:20 relatedBy:NSLayoutRelationGreaterThanOrEqual];
    

    if (data.isSelected)
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
    if ([self.delegate respondsToSelector:@selector(showItem:)])
    {    
        UBCGoodDM *item = data.data;
        [self.delegate showItem:item];
    }
}

@end
