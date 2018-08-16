//
//  UBCProfileController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 01.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCProfileController.h"
#import "UBCBalanceController.h"
#import "UBCAccountSettingsController.h"
#import "UBCUserDM.h"
#import "UBCBalanceDM.h"

#define PROFILE_ACTIVITY @"profile"
#define BALANCE_ACTIVITY @"balance"

@interface UBCProfileController () <UBDefaultTableViewDelegate>

@property (strong, nonatomic) UBDefaultTableView *tableView;

@end

@implementation UBCProfileController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_profile";
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupData];
    [self updateInfo];
}

- (void)setupTableView
{
    self.tableView = UBDefaultTableView.new;
    self.tableView.actionDelegate = self;
    [self.view addSubview:self.tableView];
    [self.view addConstraintsToFillSubview:self.tableView];
}

- (void)setupData
{
    NSMutableArray *sections = [NSMutableArray array];
    
    UBTableViewSectionData *profileSection = UBTableViewSectionData.new;
    profileSection.headerHeight = SEPARATOR_HEIGHT;
    
    UBCUserDM *user = [UBCUserDM loadProfile];
    UBTableViewRowData *data = user.rowData;
    data.name = PROFILE_ACTIVITY;
    profileSection.rows = @[data];
    [sections addObject:profileSection];
    
    UBTableViewSectionData *balanceSection = UBTableViewSectionData.new;
    balanceSection.headerHeight = SEPARATOR_HEIGHT;
    
    UBCBalanceDM *balance = [UBCBalanceDM loadBalance];
    UBTableViewRowData *data2 = UBTableViewRowData.new;
    data2.title = UBLocalizedString(@"str_my_balance", nil);
    data2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data2.name = BALANCE_ACTIVITY;
    data2.rightTitle = [NSString stringWithFormat:@"%@ UBC", balance.amountUBC];
    balanceSection.rows = @[data2];
    [sections addObject:balanceSection];
    
    [self.tableView updateWithSectionsData:sections];
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider updateBalanceWithCompletionBlock:^(BOOL success) {
        if (success)
        {
            [weakSelf setupData];
        }
    }];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([data.name isEqualToString:PROFILE_ACTIVITY])
    {
        [self.navigationController pushViewController:UBCAccountSettingsController.new animated:YES];
    }
    else if ([data.name isEqualToString:BALANCE_ACTIVITY])
    {
        [self.navigationController pushViewController:UBCBalanceController.new animated:YES];
    }
}

@end
