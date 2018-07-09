//
//  UBCTabBarController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTabBarController.h"
#import "UBCChatController.h"
#import "UBCFavouritesController.h"
#import "UBCMarketController.h"
#import "UBCSellController.h"
#import "UBCLoginController.h"
#import "UBCAppDelegate.h"

@interface UBCTabBarController () <UITabBarControllerDelegate>

@end

@implementation UBCTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor colorWithHexString:@"5b676d"];
    self.tabBar.backgroundColor = UIColor.whiteColor;
    
    [self updateControllers];
}

- (void)updateControllers
{
    [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName: UBFont.tabBarFont} forState:UIControlStateNormal];
    
    self.viewControllers = self.nonAuthorizedViewControllers;
}

- (NSArray *)nonAuthorizedViewControllers
{
    UBCMarketController *viewController1 = UBCMarketController.new;
    viewController1.tabBarItem.title = @"Market";
    viewController1.tabBarItem.image = [UIImage imageNamed:@"tab_bar_market"];
    
    UBCFavouritesController *viewController2 = UBCFavouritesController.new;
    viewController2.tabBarItem.title = @"Favorites";
    viewController2.tabBarItem.image = [UIImage imageNamed:@"tab_bar_favorites"];
    
    UBCSellController *viewController3 = UBCSellController.new;
    viewController3.tabBarItem.title = @"Sell";
    viewController3.tabBarItem.image = [[UIImage imageNamed:@"tab_bar_sell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UBCChatController *viewController4 = UBCChatController.new;
    viewController4.tabBarItem.title = @"Chat";
    viewController4.tabBarItem.image = [UIImage imageNamed:@"tab_bar_chat"];
    
    UBCLoginController *viewController5 = UBCLoginController.new;
    viewController5.tabBarItem.title = @"Sign In";
    viewController5.tabBarItem.image = [UIImage imageNamed:@"tab_bar_login"];
    
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
