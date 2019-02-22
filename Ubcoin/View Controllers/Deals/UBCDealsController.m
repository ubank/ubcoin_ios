//
//  UBCDealsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 02.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealsController.h"
#import "UBCollectionViewSwitch.h"
#import "UBCToBuyDealsView.h"
#import "UBCToSellDealsView.h"
#import "UBCGoodDetailsController.h"

#import "Ubcoin-Swift.h"

@interface UBCDealsController () <UBCDealsViewDelegate>

@property (strong, nonatomic) UBCollectionViewSwitch *dealsSwitch;
@property (strong, nonatomic) UBCToBuyDealsView *buyDealsView;
@property (strong, nonatomic) UBCToSellDealsView *sellDealsView;

@end

@implementation UBCDealsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_deals";
    
    [self setupViews];
    
    __weak typeof(self) weakSelf = self;
    [UBLocationManager.sharedLocation trackMyLocationOnce:^(BOOL success) {
        if (success)
        {
            [weakSelf.buyDealsView reloadData];
            [weakSelf.sellDealsView reloadData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.buyDealsView.tableView.refreshControll endRefreshing];
    [self.sellDealsView.tableView.refreshControll endRefreshing];
}

#pragma mark -

- (void)setupViews
{
    self.buyDealsView = [UBCToBuyDealsView.alloc initWithFrame:self.view.bounds];
    self.buyDealsView.delegate = self;
    UBCollectionViewSwitchContent *view1 = [[UBCollectionViewSwitchContent alloc] initWithTitle:UBLocalizedString(@"str_to_buy", nil)
                                                                                           view:self.buyDealsView];
    
    self.sellDealsView = [UBCToSellDealsView.alloc initWithFrame:self.view.bounds];
    self.sellDealsView.delegate = self;
    UBCollectionViewSwitchContent *view2 = [[UBCollectionViewSwitchContent alloc] initWithTitle:UBLocalizedString(@"str_to_sell", nil)
                                                                                                    view:self.sellDealsView];

    self.dealsSwitch = [[UBCollectionViewSwitch alloc] initWithFrame:self.view.bounds
                                                 withArrayOfPagesContent:@[view1, view2]];
    [self.view addSubview:self.dealsSwitch];
    [self.view addConstraintsToFillSubview:self.dealsSwitch];
}

#pragma mark - UBCDealsViewDelegate

- (void)showItem:(UBCGoodDM *)item
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
