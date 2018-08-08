//
//  UBCDealsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 02.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealsController.h"
#import "UBCollectionViewSwitch.h"

@interface UBCDealsController ()

@property (strong, nonatomic) UBCollectionViewSwitch *dealsSwitch;

@end

@implementation UBCDealsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_deals";
    
    [self setupViews];
}

- (void)setupViews
{
    UBCollectionViewSwitchContent *view1 = [[UBCollectionViewSwitchContent alloc] initWithTitle:UBLocalizedString(@"str_to_sell", nil)
                                                                                                    view:nil];
    UBCollectionViewSwitchContent *view2 = [[UBCollectionViewSwitchContent alloc] initWithTitle:UBLocalizedString(@"str_to_buy", nil)
                                                                                                    view:nil];
    
    self.dealsSwitch = [[UBCollectionViewSwitch alloc] initWithFrame:self.view.bounds
                                                 withArrayOfPagesContent:@[view1, view2]];
    [self.view addSubview:self.dealsSwitch];
    [self.view addConstraintsToFillSubview:self.dealsSwitch];
}

@end
