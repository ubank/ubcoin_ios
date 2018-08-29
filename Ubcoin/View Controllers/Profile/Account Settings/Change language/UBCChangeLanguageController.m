//
//  UBCChangeLanguageController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 16.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCChangeLanguageController.h"
#import "UBCAccountSettingsDM.h"

@interface UBCChangeLanguageController () <UBDefaultTableViewDelegate>

@property (strong, nonatomic) UBDefaultTableView *tableView;

@end

@implementation UBCChangeLanguageController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_language";
    
    [self setupTableView];
    [self.tableView updateWithRowsData:[UBCAccountSettingsDM currentLocalizations]];
}

- (void)setupTableView
{
    self.tableView = UBDefaultTableView.new;
    self.tableView.actionDelegate = self;
    [self.view addSubview:self.tableView];
    [self.view addConstraintsToFillSubview:self.tableView];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBLocal.shared.language = data.name;
    [self.tableView updateWithRowsData:[UBCAccountSettingsDM currentLocalizations]];
}

@end
