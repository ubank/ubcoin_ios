//
//  UBCBaseDealsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCBaseDealsView.h"
#import "UBCKeyChain.h"

@interface UBCBaseDealsView()

@end

@implementation UBCBaseDealsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupTableView];
        [self setupEmptyView];
        [self updateInfo];
    }
    
    return self;
}

- (void)setupTableView
{
    self.tableView = UBDefaultTableView.new;
    self.tableView.actionDelegate = self;
    self.tableView.backgroundColor = UBColor.backgroundColor;
    [self addSubview:self.tableView];
    [self addConstraintsToFillSubview:self.tableView];
    
    if (UBCKeyChain.authorization)
    {
        __weak typeof(self) weakSelf = self;
        [self.tableView setupRefreshControllWithActionBlock:^{
            weakSelf.pageNumber = 0;
            [weakSelf updateInfo];
        }];
    }
}

- (void)setupEmptyView
{
    self.tableView.emptyView.icon.image = [UIImage imageNamed:@"empty_deals"];
    self.tableView.emptyView.title.text = UBLocalizedString(@"str_no_active_deals", nil);
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)updateInfo
{
    
}

- (void)handleResponse:(NSArray *)deals
{
    [self.tableView.refreshControll endRefreshing];
    if (deals)
    {
        if (self.pageNumber == 0)
        {
            self.items = [NSMutableArray array];
        }
        [self.items addObjectsFromArray:deals];
        self.pageNumber++;
    }
    self.tableView.emptyView.hidden = self.items.count > 0;
    [self.tableView updateWithRowsData:self.items];
}

- (NSAttributedString *)infoStringWithString:(NSString *)string
{
    NSTextAttachment *tgIcon = NSTextAttachment.new;
    tgIcon.image = [UIImage imageNamed:@"icTg"];
    tgIcon.bounds = CGRectMake(0, (UBFont.descFont.pointSize - tgIcon.image.size.height), tgIcon.image.size.width, tgIcon.image.size.height);
    
    NSMutableAttributedString *info = [NSMutableAttributedString.alloc initWithAttributedString:[NSAttributedString attributedStringWithAttachment:tgIcon]];
    
    NSString *text = [NSString stringWithFormat:@" %@ ", string];
    [info appendAttributedString:[NSAttributedString.alloc initWithString:text attributes:@{NSForegroundColorAttributeName: UBColor.descColor, NSFontAttributeName: UBFont.descFont}]];
    
    return info;
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCDealDM *deal = data.data;
    [self.delegate openChatForItem:deal.item];
}

- (void)updatePagination
{
    [self updateInfo];
}

@end
