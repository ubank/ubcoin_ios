//
//  UBCSuccessRegistrationView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 01.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSuccessRegistrationView.h"

@interface UBCSuccessRegistrationView ()

@end

@implementation UBCSuccessRegistrationView

+ (void)show
{
    UBCSuccessRegistrationView *view = UBCSuccessRegistrationView.loadFromXib;
    [view show];
}

- (void)show
{
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    [window addSubview:self];
    [window addConstraintsToFillSubview:self];
}

- (IBAction)hide
{
    [self fadeOutWithCompletion:^{
        [self removeFromSuperview];
    }];
}

@end
