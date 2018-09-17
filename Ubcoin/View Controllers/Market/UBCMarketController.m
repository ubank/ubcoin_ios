//
//  UBCMainController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCMarketController.h"
#import "UBCFiltersListController.h"
#import "UBCGoodsCollectionView.h"
#import "UBCGoodDetailsController.h"

@interface UBCMarketController () <UISearchControllerDelegate, UISearchBarDelegate, UBCGoodsCollectionViewDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UBCGoodsCollectionView *collectionView;

@property (strong, nonatomic) NSArray *discounts;
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;

@end

@implementation UBCMarketController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationContainer.image = [UIImage imageNamed:@"general_logo_black"];
//    self.navigationContainer.rightImageTitle = @"general_filter";
    
    self.pageNumber = 0;
    self.items = [NSMutableArray array];
    
    [self setupCollectionView];
//    [self setupSearch];
    
    __weak typeof(self) weakSelf = self;
    [UBLocationManager.sharedLocation trackMyLocationOnce:^(BOOL success) {
        if (success)
        {
            [weakSelf.collectionView reloadData];
            [weakSelf refreshControlUpdate];
        }
    }];
    
    [self startActivityIndicatorImmediately];
    [self updateInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favoritesChanged:)
                                                 name:kNotificationFavoritesChanged
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.collectionView.refreshControl endRefreshing];
}

#pragma mark -

- (void)setupCollectionView
{
    self.collectionView = UBCGoodsCollectionView.new;
    self.collectionView.actionsDelegate = self;
    [self.view addSubview:self.collectionView];
    [self.view addConstraintsToFillSubview:self.collectionView];
}

- (void)setupSearch
{
    self.searchController = [UISearchController.alloc initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.tintColor = UBColor.titleColor;
    self.searchController.searchBar.barTintColor = UIColor.whiteColor;
    self.searchController.searchBar.layer.borderWidth = 1;
    self.searchController.searchBar.layer.borderColor = UIColor.whiteColor.CGColor;
    self.searchController.searchBar.placeholder = UBLocalizedString(@"str_market_search", nil);
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.searchController.searchBar];
    
    [self.searchController.searchBar sizeToFit];
    [self.view setTopConstraintToSubview:self.collectionView withValue:self.searchController.searchBar.height];
    
    self.searchController.searchBar.showsBookmarkButton = YES;
    [self.searchController.searchBar setImage:[UIImage imageNamed:@"market_voice"]
                             forSearchBarIcon:UISearchBarIconBookmark
                                        state:UIControlStateNormal];
    
    for (UIView *subView in self.searchController.searchBar.subviews)
    {
        for (UIView *subSubView in subView.subviews)
        {
            if ([subSubView isKindOfClass:UITextField.class])
            {
                subSubView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
            }
        }
    }
    
    self.definesPresentationContext = !self.tabBarController;
}

#pragma mark -

- (void)updateInfo
{
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_enter(serviceGroup);
    [UBCDataProvider.sharedProvider discountsWithCompletionBlock:^(BOOL success, NSArray *discounts) {
        if (discounts)
        {
            weakSelf.discounts = discounts;
        }
        
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_enter(serviceGroup);
    [UBCDataProvider.sharedProvider goodsListWithPageNumber:self.pageNumber
                                        withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore) {
        if (success)
        {
            if (weakSelf.pageNumber == 0)
            {
                weakSelf.items = [NSMutableArray array];
            }
            [weakSelf.items addObjectsFromArray:goods];
            weakSelf.collectionView.canLoadMore = canLoadMore;
            weakSelf.pageNumber++;
        }
        
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        [weakSelf handleResponse];
    });
}

- (void)handleResponse
{
    [self stopActivityIndicator];
    [self.collectionView.refreshControl endRefreshing];
    self.collectionView.discounts = self.discounts;
    self.collectionView.items = self.items;
}

- (void)favoritesChanged:(NSNotification *)notification
{
    if (!self.view.window)
    {
        UBCGoodDM *item = notification.object;
        
        NSUInteger index = NSNotFound;
        for (UBCGoodDM *currentItem in self.items)
        {
            if ([currentItem.ID isEqualToString:item.ID])
            {
                index = [self.items indexOfObject:currentItem];
                break;
            }
        }
        
        if (index != NSNotFound)
        {
            [self.items replaceObjectAtIndex:index withObject:item];
            self.collectionView.items = self.items;
        }
    }
}

#pragma mark - Actions

- (void)rightBarButtonClick:(id)sender
{
    UBCFiltersListController *controller = [[UBCFiltersListController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithText:searchBar.text];
}

- (void)searchWithText:(NSString *)searchTerm
{
    [self cancelAllTasks];
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [self dismissSearchControllerAnimated:YES];
}

- (void)dismissSearchControllerAnimated:(BOOL)animated
{
    [self searchWithText:nil];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - UBCGoodsCollectionViewDelegate

- (void)didSelectDiscount:(UBCDiscountDM *)discount
{
    
}

- (void)didSelectItem:(UBCGoodDM *)item
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:item];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updatePagination
{
    [self updateInfo];
}

- (void)refreshControlUpdate
{
    self.pageNumber = 0;
    [self updateInfo];
}

@end
