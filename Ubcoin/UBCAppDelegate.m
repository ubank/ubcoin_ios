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
    UBColor.navigationTitleColor = [UIColor colorWithHexString:@"403d45"];
}

- (void)setupFonts
{
    UBFont.navigationFont = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    UBFont.tabBarFont = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
}

@end
