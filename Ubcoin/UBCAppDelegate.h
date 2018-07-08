//
//  UBCAppDelegate.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 29.06.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#define mainAppDelegate ((UBCAppDelegate *)UIApplication.sharedApplication.delegate)

@interface UBCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UBNavigationController *navigationController;

@end

