//
//  UBCFavouritesController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCFavouritesController.h"
#import "UBCGoodDetailsController.h"
#import "UBCFavouriteCell.h"
#import "UBCGoodDM.h"

@interface UBCFavouritesController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation UBCFavouritesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Favorites";
    
    self.items = [NSMutableArray array];
    
    [self setupTableView];
    [self updateInfo];
}

- (void)setupTableView
{
    self.tableView = UITableView.new;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 95;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.backgroundColor = UBColor.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(UBCFavouriteCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UBCFavouriteCell.class)];
    
    [self.view addSubview:self.tableView];
    [self.view addConstraintsToFillSubview:self.tableView];
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider favoritesListWithPageNumber:0
                                            withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore)
     {
         if (goods)
         {
             [weakSelf.items addObjectsFromArray:goods];
         }
         weakSelf.tableView.hidden = weakSelf.items.count == 0;
         [weakSelf.tableView reloadData];
     }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UBCFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UBCFavouriteCell.class)];
    cell.content = self.items[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:self.items[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
