//
//  UBCProfileController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 01.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCProfileController.h"
#import "UBCBalanceController.h"
#import "UBCDealsController.h"
#import "UBCAccountSettingsController.h"
#import "UBCUserDM.h"
#import "UBCBalanceDM.h"

#define PROFILE_ACTIVITY @"profile"
#define UBC_BALANCE_ACTIVITY @"ubc balance"
#define ETH_BALANCE_ACTIVITY @"eth balance"
#define DEALS_ACTIVITY @"deals"

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
    data2.icon = [UIImage imageNamed:@"ubc_icon"];
    data2.title = balance.amountUBC.priceString;
    data2.desc = @"UBC";
    data2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data2.name = UBC_BALANCE_ACTIVITY;

    UBTableViewRowData *data3 = UBTableViewRowData.new;
    data3.icon = [UIImage imageNamed:@"eth_icon"];
    data3.title = balance.amountETH.coinsPriceString;
    data3.desc = @"ETH";
    data3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data3.name = ETH_BALANCE_ACTIVITY;

    balanceSection.rows = @[data2, data3];
    [sections addObject:balanceSection];
    
    UBTableViewSectionData *dealsSection = UBTableViewSectionData.new;
    dealsSection.headerHeight = SEPARATOR_HEIGHT;
    
    UBTableViewRowData *data4 = UBTableViewRowData.new;
    data4.title = UBLocalizedString(@"str_deals", nil);
    data4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data4.name = DEALS_ACTIVITY;
    
    dealsSection.rows = @[data4];
    [sections addObject:dealsSection];
    
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
    else if ([data.name isEqualToString:UBC_BALANCE_ACTIVITY] ||
             [data.name isEqualToString:ETH_BALANCE_ACTIVITY])
    {
        BOOL isETH = [data.name isEqualToString:ETH_BALANCE_ACTIVITY];
        UBCBalanceController *controller = [[UBCBalanceController alloc] initWithETH:isETH];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([data.name isEqualToString:DEALS_ACTIVITY])
    {
        [self.navigationController pushViewController:UBCDealsController.new animated:YES];
    }
}

@end
