//
//  UBCAccountSettingsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCAccountSettingsController.h"
#import "UBCAccountSettingsDM.h"
#import "UBCChangeNameController.h"
#import "UBCChangeLanguageController.h"
#import "UBCAppDelegate.h"
#import "UBCKeyChain.h"
#import "UBCUserDM.h"

@interface UBCAccountSettingsController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;

@end

@implementation UBCAccountSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_account_settings";
    
    [self setupFooter];
    [self updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView updateWithSectionsData:[UBCAccountSettingsDM fields]];
}

- (void)setupFooter
{
    UIView *footerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, self.tableView.width, 110)];
    footerView.backgroundColor = UIColor.clearColor;
    
    HUBGeneralButton *button = [HUBGeneralButton.alloc initWithFrame:CGRectMake(0, 30, footerView.width, 50)];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.type = HUBGeneralButtonTypeWhiteWithRedTitle;
    button.roundCorners = NO;
    [button setTitle:UBLocalizedString(@"str_logout", nil)];
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    self.tableView.tableFooterView = footerView;
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider userInfoWithCompletionBlock:^(BOOL success) {
        if (success)
        {
            [weakSelf.tableView updateWithSectionsData:[UBCAccountSettingsDM fields]];
        }
    }];
}

#pragma mark - Actions

- (void)logout
{
    __weak typeof(self) weakSelf = self;
    [UBAlert showAlertWithTitle:nil
                     andMessage:UBLocalizedString(@"str_are_you_sure_you_want_to_sign_out", nil)
                titleButtonMain:UBLocalizedString(@"ui_alert_button_yes", nil)
              titleButtonCancel:UBLocalizedString(@"ui_alert_button_no", nil)
            withCompletionBlock:^(NSInteger index) {
                if (index != CANCEL_INDEX)
                {
                    [weakSelf startActivityIndicator];
                    [UBCDataProvider.sharedProvider logoutWithCompletionBlock:^(BOOL success) {
                        [weakSelf stopActivityIndicator];
                        if (success)
                        {
                            [UBCUserDM clearUserData];
                            [UBCKeyChain removeAuthorization];
                            [mainAppDelegate setupStack];
                        }
                    }];
                }
            }];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([data.name isEqualToString:CHANGE_NAME_ACTION])
    {
        [self.navigationController pushViewController:UBCChangeNameController.new animated:YES];
    }
    else if ([data.name isEqualToString:CHANGE_COUNTRY_ACTION])
    {
        
    }
    else if ([data.name isEqualToString:CHANGE_LANGUAGE_ACTION])
    {
        [self.navigationController pushViewController:UBCChangeLanguageController.new animated:YES];
    }
    else if ([data.name isEqualToString:SHOW_REVIEWS_ACTION])
    {
        
    }
}

- (void)prepareCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data
{
    cell.title.textColor = UBColor.descColor;
}

- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if (data.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.rightTitle.textColor = UBColor.descColor;
    }
    else
    {
        cell.rightTitle.textColor = UBColor.titleColor;
    }
}

@end
