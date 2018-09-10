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

#pragma mark - UBDefaultTableViewDelegate

- (void)updatePagination
{
    [self updateInfo];
}

@end
