//
//  UBCMainController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCMarketController.h"
#import "UBCGoodsCollectionView.h"
#import "UBCGoodDetailsController.h"

#import "Ubcoin-Swift.h"

@interface UBCMarketController () <UISearchControllerDelegate, UISearchBarDelegate, UBCGoodsCollectionViewDelegate>

@property (strong, nonatomic) UIStackView *stackView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UBCGoodsCollectionView *collectionView;
@property (strong, nonatomic) UBCFiltersView *filtersView;

@property (strong, nonatomic) UBCFilterDM *filterDM;
@property (strong, nonatomic) NSArray *discounts;
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;
@property (strong, nonatomic) NSURLSessionDataTask *task;

@end

@implementation UBCMarketController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationContainer.image = [UIImage imageNamed:@"general_logo_black"];
    self.navigationContainer.leftImageTitle = @"market_category_filter";
    self.navigationContainer.rightImageTitle = @"general_filter";
    
    self.pageNumber = 0;
    self.items = [NSMutableArray array];
    self.filterDM = UBCFilterDM.new;
    
    [self setupViews];
    
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

- (void)setupViews
{
    self.stackView = UIStackView.new;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    [self.view addSubview:self.stackView];
    [self.view addConstraintsToFillSubview:self.stackView];
    
    [self setupSearch];
    [self setupFiltersView];
    [self setupCollectionView];
}

- (void)setupFiltersView
{
    self.filtersView = UBCFiltersView.new;
    [self.filtersView setHeightConstraintWithValue:55];
    [self.stackView addArrangedSubview:self.filtersView];
    self.filtersView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.filtersView setFiltersChanged:^(NSArray<UBCFilterParam *> *filters) {
        weakSelf.filterDM.filters = filters;
        [weakSelf applyFilters];
    }];
}

- (void)setupCollectionView
{
    self.collectionView = UBCGoodsCollectionView.new;
    self.collectionView.actionsDelegate = self;
    [self.stackView addArrangedSubview:self.collectionView];
    
    self.collectionView.emptyView.icon.image = [UIImage imageNamed:@"empty_results"];
    self.collectionView.emptyView.title.text = UBLocalizedString(@"str_no_result_title", nil);
    self.collectionView.emptyView.desc.text = UBLocalizedString(@"str_no_result_desc", nil);
}

- (void)setupSearch
{
    self.searchBar = UISearchBar.new;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = UBColor.titleColor;
    self.searchBar.barTintColor = UIColor.whiteColor;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = UIColor.whiteColor.CGColor;
    self.searchBar.placeholder = UBLocalizedString(@"str_market_search", nil);
    self.searchBar.returnKeyType = UIReturnKeySearch;
    [self.searchBar sizeToFit];
    [self.stackView addArrangedSubview:self.searchBar];
    
    for (UIView *subView in self.searchBar.subviews)
    {
        for (UIView *subSubView in subView.subviews)
        {
            if ([subSubView isKindOfClass:UITextField.class])
            {
                subSubView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
            }
        }
    }
}

#pragma mark -

- (void)applyFilters
{
    [self.filtersView updateWithFilters:self.filterDM.filters];
    
    self.pageNumber = 0;
    self.items = [NSMutableArray array];
    self.collectionView.canLoadMore = NO;
    
    if (![self.searchBar.text isNotEmpty])
    {
        [self startActivityIndicator];
    }
    
    [self updateInfo];
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [self.task cancel];
    
    NSString *filtersValues = [self.filterDM filterValues];
    if ([self.searchBar.text isNotEmpty])
    {
        NSString *searchTerm = self.searchBar.text.replaceNormalSpacesWithNonBreakingSpaces;
        filtersValues = [filtersValues stringByAppendingFormat:@"&searchLine=%@", searchTerm.urlEncodeUTF8];
    }
    self.task = [UBCDataProvider.sharedProvider goodsListWithPageNumber:self.pageNumber
                                                             andFilters:filtersValues
                                                    withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore)
                 {
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
                     [weakSelf handleResponse];
                 }];
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

- (void)navigationButtonBackClick:(id)sender
{
    UBCCategoriesFilterController *controller = [[UBCCategoriesFilterController alloc] initWithSelectedCategories:self.filterDM.categoryFilters];
    [self.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [controller setCompletion:^(NSArray<UBCFilterParam *> * selectedCategoryFilters) {
        [weakSelf.filterDM updateCategoryFiltersWithSelectedCategoryFilters:selectedCategoryFilters];
        [weakSelf applyFilters];
    }];
}

- (void)rightBarButtonClick:(id)sender
{
    UBCFiltersListController *controller = [[UBCFiltersListController alloc] initWithModel:self.filterDM.copy];
    [self.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [controller setCompletion:^(UBCFilterDM *model) {
        weakSelf.filterDM = model;
        [weakSelf applyFilters];
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self applyFilters];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self applyFilters];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
