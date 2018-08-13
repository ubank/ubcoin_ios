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
    
    self.tableView.emptyView.icon.image = [UIImage imageNamed:@"empty_favorites"];
    self.tableView.emptyView.title.text = UBLocalizedString(@"str_no_favorite_title", nil);
    self.tableView.emptyView.desc.text = UBLocalizedString(@"str_no_favorite_desc", nil);
    self.tableView.backgroundColor = UBColor.backgroundColor;
    
    if (UBCKeyChain.authorization)
    {
        [self startActivityIndicatorImmediately];
        [self updateInfo];
        
        __weak typeof(self) weakSelf = self;
        [self.tableView setupRefreshControllWithActionBlock:^{
            weakSelf.pageNumber = 0;
            [weakSelf updateInfo];
        }];
    }
    else
    {
        self.tableView.emptyView.hidden = NO;
    }
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider favoritesListWithPageNumber:self.pageNumber
                                            withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore)
     {
         [weakSelf stopActivityIndicator];
         [weakSelf.tableView.refreshControll endRefreshing];
         if (success)
         {
             weakSelf.tableView.canLoadMore = canLoadMore;
         }
         
         if (goods)
         {
             if (weakSelf.pageNumber == 0)
             {
                 weakSelf.items = [NSMutableArray array];
             }
             [weakSelf.items addObjectsFromArray:goods];
             weakSelf.pageNumber++;
         }
         weakSelf.tableView.emptyView.hidden = weakSelf.items.count > 0;
         [weakSelf.tableView updateWithRowsData:weakSelf.items];
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
