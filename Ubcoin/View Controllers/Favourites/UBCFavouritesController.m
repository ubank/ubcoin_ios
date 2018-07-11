//
//  UBCFavouritesController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCFavouritesController.h"
#import "UBCGoodsCollectionView.h"
#import "UBCGoodDetailsController.h"
#import "UBCGoodDM.h"

@interface UBCFavouritesController () <UBCGoodsCollectionViewDelegate>

@property (strong, nonatomic) UBCGoodsCollectionView *collectionView;

@end

@implementation UBCFavouritesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Favorites";
    
    [self setupCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo)
                                                 name:kNotificationFavoritesChanged
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateInfo];
}

- (void)setupCollectionView
{
    self.collectionView = UBCGoodsCollectionView.new;
    self.collectionView.actionsDelegate = self;
    [self.view addSubview:self.collectionView];
    [self.view addConstraintsToFillSubview:self.collectionView];
}

- (void)updateInfo
{
    self.collectionView.items = [UBCGoodDM favorites];
}

#pragma mark - UBCGoodsCollectionViewDelegate

- (void)didSelectItem:(UBCGoodDM *)item
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:item];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshControlUpdate
{
    [self.collectionView.refreshControl endRefreshing];
}

@end
