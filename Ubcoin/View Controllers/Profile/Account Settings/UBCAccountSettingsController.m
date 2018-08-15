//
//  UBCAccountSettingsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCAccountSettingsController.h"
#import "UBCAccountSettingsDM.h"

@interface UBCAccountSettingsController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;

@end

@implementation UBCAccountSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_account_settings";
    
    [self.tableView updateWithSectionsData:[UBCAccountSettingsDM fields]];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if ([data.name isEqualToString:CHANGE_NAME_ACTION])
    {
        
    }
    else if ([data.name isEqualToString:CHANGE_COUNTRY_ACTION])
    {
        
    }
    else if ([data.name isEqualToString:CHANGE_LANGUAGE_ACTION])
    {
        
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
