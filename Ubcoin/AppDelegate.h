//
//  AppDelegate.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 29.06.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mainAppDelegate ((AppDelegate *)UIApplication.sharedApplication.delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UBNavigationController *navigationController;

@end

