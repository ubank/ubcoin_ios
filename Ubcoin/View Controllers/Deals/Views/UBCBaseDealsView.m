//
//  UBCBaseDealsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCBaseDealsView.h"

@interface UBCBaseDealsView()

@end

@implementation UBCBaseDealsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupTableView];
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
    
    __weak typeof(self) weakSelf = self;
    [self.tableView setupRefreshControllWithActionBlock:^{
        weakSelf.pageNumber = 0;
        [weakSelf updateInfo];
    }];
}

- (void)updateInfo
{
    
}

#pragma mark - UBDefaultTableViewDelegate

- (void)updatePagination
{
    [self updateInfo];
}

@end
