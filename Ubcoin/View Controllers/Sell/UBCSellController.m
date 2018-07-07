//
//  UBCSellController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSellController.h"

@interface UBCSellController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UBTableView *tableView;

@end


@implementation UBCSellController

#pragma mark - View Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)setupViews
{
    self.tableView = UBTableView.new;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addConstraintsToFillSubview:self.tableView];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
