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
#import "UBCKeyChain.h"
#import "UBCGoodDM.h"

@interface UBCFavouritesController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;

@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;

@end

@implementation UBCFavouritesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"str_favorites";
    
    self.pageNumber = 0;
    self.items = [NSMutableArray array];
    
    self.tableView.backgroundColor = UBColor.backgroundColor;
    __weak typeof(self) weakSelf = self;
    [self.tableView setupRefreshControllWithActionBlock:^{
        weakSelf.pageNumber = 0;
        [weakSelf updateInfo];
    }];
    
    if (UBCKeyChain.authorization)
    {
        [self startActivityIndicatorImmediately];
        [self updateInfo];
    }
    else
    {
        self.tableView.hidden = YES;
    }
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider favoritesListWithPageNumber:self.pageNumber
                                            withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore)
     {
         [weakSelf stopActivityIndicator];
         if (goods)
         {
             if (weakSelf.pageNumber == 0)
             {
                 weakSelf.items = [NSMutableArray array];
             }
             [weakSelf.items addObjectsFromArray:goods];
             weakSelf.pageNumber++;
         }
         weakSelf.tableView.hidden = weakSelf.items.count == 0;
         [weakSelf.tableView reloadData];
     }];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:data.data];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updatePagination
{
    [self updateInfo];
}

@end
