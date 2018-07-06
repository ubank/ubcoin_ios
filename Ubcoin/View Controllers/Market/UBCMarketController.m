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

@interface UBCMarketController () <UISearchControllerDelegate, UISearchBarDelegate, UBCGoodsCollectionViewDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UBCGoodsCollectionView *collectionView;

@end

@implementation UBCMarketController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationContainer.rightImageTitle = @"icFilter";
    
    [self setupCollectionView];
    [self setupSearch];
}

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
    self.searchController.searchBar.tintColor = BROWN_COLOR;
    self.searchController.searchBar.barTintColor = UIColor.whiteColor;
    self.searchController.searchBar.layer.borderWidth = 1;
    self.searchController.searchBar.layer.borderColor = UIColor.whiteColor.CGColor;
    self.searchController.searchBar.placeholder = @"I'm looking for...";
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    [self.collectionView addSubview:self.searchController.searchBar];
    
    [self.searchController.searchBar sizeToFit];
    
    for (UIView *subView in self.searchController.searchBar.subviews)
    {
        for (UIView *subSubView in subView.subviews)
        {
            if ([subSubView isKindOfClass:UITextField.class])
            {
                subSubView.backgroundColor = LIGHT_GRAY_COLOR2;
            }
        }
    }
    
    self.definesPresentationContext = !self.tabBarController;
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

#pragma mark - UBCGoodsCollectionViewDelegate

- (void)didSelectItem:(UBCGoodDM *)item
{
    
}

- (void)updatePagination
{
    
}

- (void)refreshControlUpdate
{
    
}

@end
