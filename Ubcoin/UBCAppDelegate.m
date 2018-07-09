//
//  UBCAppDelegate.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 29.06.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCAppDelegate.h"
#import "UBCTabBarController.h"

@interface UBCAppDelegate ()

@property (strong, nonatomic) UBCTabBarController *tabBar;

@end


@implementation UBCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupColors];
    [self setupFonts];
    
    [self setupStack];
    
    return YES;
}

#pragma mark -

- (void)setupStack
{
    self.tabBar = UBCTabBarController.new;
    self.navigationController = [UBNavigationController.alloc initWithRootViewController:self.tabBar];
    
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}

- (void)setupColors
{
    UBColor.navigationTitleColor = [UIColor colorWithRed:64 / 255.0 green:61 / 255.0 blue:69 / 255.0 alpha:1];
    UBColor.navigationTintColor = [UIColor colorWithRed:91 / 255.0 green:103 / 255.0 blue:109 / 255.0 alpha:1];
    UBColor.titleColor = [UIColor colorWithRed:42 / 255.0 green:42 / 255.0 blue:42 / 255.0 alpha:1];
    UBColor.descColor = [UIColor colorWithRed:142 / 255.0 green:142 / 255.0 blue:142 / 255.0 alpha:1];
}

- (void)setupFonts
{
    UBFont.navigationFont = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    UBFont.tabBarFont = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    UBFont.titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    UBFont.buttonFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
}

@end
