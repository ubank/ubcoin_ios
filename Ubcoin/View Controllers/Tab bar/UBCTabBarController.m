//
//  UBCTabBarController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTabBarController.h"
#import "UBCDealsController.h"
#import "UBCFavouritesController.h"
#import "UBCMarketController.h"
#import "UBCProfileController.h"
#import "UBCAppDelegate.h"
#import "UBCKeyChain.h"

#import "Ubcoin-Swift.h"

@interface UBCTabBarController () <UITabBarControllerDelegate>

@end

@implementation UBCTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.tintColor = UBCColor.tabBar;
    self.tabBar.backgroundColor = UIColor.whiteColor;
    
    [self updateControllers];
}

- (void)updateControllers
{
    [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName: UBFont.tabBarFont} forState:UIControlStateNormal];
    
    self.viewControllers = UBCKeyChain.authorization ? self.authorizedViewControllers : self.nonAuthorizedViewControllers;
}

- (NSArray *)nonAuthorizedViewControllers
{
    UBCMarketController *viewController1 = UBCMarketController.new;
    viewController1.tabBarItem.title = UBLocalizedString(@"str_market", nil);
    viewController1.tabBarItem.image = [UIImage imageNamed:@"tab_bar_market"];
    
    UBCFavouritesController *viewController2 = UBCFavouritesController.new;
    viewController2.tabBarItem.title = UBLocalizedString(@"str_favorites", nil);
    viewController2.tabBarItem.image = [UIImage imageNamed:@"tab_bar_favorites"];
    
    UBCStartLoginController *viewController3 = UBCStartLoginController.new;
    viewController3.tabBarItem.title = UBLocalizedString(@"str_sell", nil);
    viewController3.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_sell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UBCDealsController *viewController4 = UBCDealsController.new;
    viewController4.tabBarItem.title = UBLocalizedString(@"str_deals", nil);
    viewController4.tabBarItem.image = [UIImage imageNamed:@"tab_bar_deals"];
    
    UBCStartLoginController *viewController5 = UBCStartLoginController.new;
    viewController5.tabBarItem.title = UBLocalizedString(@"str_sign_in", nil);
    viewController5.tabBarItem.image = [UIImage imageNamed:@"tab_bar_login"];
    
    return @[viewController1, viewController2, viewController3, viewController4, viewController5];
}

- (NSArray *)authorizedViewControllers
{
    UBCMarketController *viewController1 = UBCMarketController.new;
    viewController1.tabBarItem.title = UBLocalizedString(@"str_market", nil);
    viewController1.tabBarItem.image = [UIImage imageNamed:@"tab_bar_market"];
    
    UBCFavouritesController *viewController2 = UBCFavouritesController.new;
    viewController2.tabBarItem.title = UBLocalizedString(@"str_favorites", nil);
    viewController2.tabBarItem.image = [UIImage imageNamed:@"tab_bar_favorites"];
    
    UBCSellController *viewController3 = UBCSellController.new;
    viewController3.tabBarItem.title = UBLocalizedString(@"str_sell", nil);
    viewController3.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_sell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UBCDealsController *viewController4 = UBCDealsController.new;
    viewController4.tabBarItem.title = UBLocalizedString(@"str_deals", nil);
    viewController4.tabBarItem.image = [UIImage imageNamed:@"tab_bar_deals"];
    
    UBCProfileController *viewController5 = UBCProfileController.new;
    viewController5.tabBarItem.title = UBLocalizedString(@"str_profile", nil);
    viewController5.tabBarItem.image = [UIImage imageNamed:@"tab_bar_profile"];
    
    return @[viewController1, viewController2, viewController3, viewController4, viewController5];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [(UBNavigationBar *)mainAppDelegate.navigationController.navigationBar updateCurrentNavigationItem];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.selectedViewController;
}

@end
