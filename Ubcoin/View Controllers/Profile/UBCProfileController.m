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
    UBCUserDM *user = [UBCUserDM loadProfile];
    
    UBTableViewSectionData *profileSection = UBTableViewSectionData.new;
    profileSection.headerHeight = SEPARATOR_HEIGHT;
    
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.title = user.name;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.name = PROFILE_ACTIVITY;
    profileSection.rows = @[data];
    
    UBTableViewSectionData *balanceSection = UBTableViewSectionData.new;
    balanceSection.headerHeight = SEPARATOR_HEIGHT;
    
    UBTableViewRowData *data2 = UBTableViewRowData.new;
    data2.title = UBLocalizedString(@"str_my_balance", nil);
    data2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data2.name = BALANCE_ACTIVITY;
    balanceSection.rows = @[data2];
    
    [self.tableView updateWithSectionsData:sections];
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
