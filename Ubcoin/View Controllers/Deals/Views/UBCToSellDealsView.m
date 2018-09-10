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

#pragma mark -

- (NSAttributedString *)infoStringWithDeals:(NSArray *)deals
{
    if (deals.count > 0)
    {
        if (deals.count == 1)
        {
            UBCDealDM *deal = deals.firstObject;
            return [self infoStringWithString:deal.buyer.name];
        }
        else
        {
            NSString *text = [NSString stringWithFormat:@" %d %@", (int)deals.count, UBLocalizedString(@"str_active_buyers", nil)];
            return [self infoStringWithString:text];
        }
    }
    return nil;
}

- (NSAttributedString *)infoStringWithString:(NSString *)string
{
    NSTextAttachment *tgIcon = NSTextAttachment.new;
    tgIcon.image = [UIImage imageNamed:@"icDialog"];
    tgIcon.bounds = CGRectMake(0, (UBFont.descFont.pointSize - tgIcon.image.size.height) - 3, tgIcon.image.size.width, tgIcon.image.size.height);
    
    NSMutableAttributedString *info = [NSMutableAttributedString.alloc initWithAttributedString:[NSAttributedString attributedStringWithAttachment:tgIcon]];
    
    NSString *text = [NSString stringWithFormat:@" %@", string];
    [info appendAttributedString:[NSAttributedString.alloc initWithString:text attributes:@{NSForegroundColorAttributeName: UBColor.descColor, NSFontAttributeName: UBFont.descFont}]];
    
    return info;
}

#pragma mark - UBDefaultTableViewDelegate

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCGoodDM *item = data.data;
    
    UBCDealCell *dealCell = (UBCDealCell *)cell;
    dealCell.info.attributedText = [self infoStringWithDeals:item.deals];
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
