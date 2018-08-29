//
//  UBCToast.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 29.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBCToast : UIView

+ (void)showToastWithMessage:(NSString *)message;
+ (void)showErrorToastWithMessage:(NSString *)message;

- (void)show;
- (void)hide;

@end
