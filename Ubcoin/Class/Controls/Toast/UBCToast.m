//
//  UBCToast.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 29.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCToast.h"

@implementation UBCToast

+ (void)showErrorToastWithMessage:(NSString *)message
{
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    
    UBCToast *toast = [UBCToast.alloc initWithMessage:message
                                      backgroundColor:[UIColor colorWithHexString:@"e33f5e"] andMaxWidth:window.width - 30];
    toast.originX = (window.width - toast.width) / 2;
    toast.originY = 100;
    [window addSubview:toast];
    
    [toast show];
}

+ (void)showToastWithMessage:(NSString *)message
{
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    
    UBCToast *toast = [UBCToast.alloc initWithMessage:message
                                      backgroundColor:[UIColor colorWithWhite:0 alpha:0.7] andMaxWidth:window.width - 30];
    toast.originX = (window.width - toast.width) / 2;
    toast.originY = 100;
    [window addSubview:toast];
    
    [toast show];
}

- (instancetype)initWithMessage:(NSString *)message
                backgroundColor:(UIColor *)backgroundColor
                    andMaxWidth:(CGFloat)maxWidth
{
    self = super.init;
    
    if (self)
    {
        self.backgroundColor = UIColor.clearColor;
        
        UIView *background = [UIView.alloc initWithFrame:self.bounds];
        background.backgroundColor = backgroundColor;
        background.layer.masksToBounds = YES;
        [self addSubview:background];
        [self addConstraintsToFillSubviewWithoutSafeArea:background];
        
        UILabel *title = UILabel.new;
        title.backgroundColor = UIColor.clearColor;
        title.textColor = UIColor.whiteColor;
        title.text = UBLocalizedString(message, nil);
        title.textAlignment = NSTextAlignmentCenter;
        title.font = UBFont.titleFont;
        title.numberOfLines = 0;
        
        CGSize textSize = [title.text calculateSizeWithFont:title.font constrainedToSize:CGSizeMake(maxWidth - 40, CGFLOAT_MAX)];
        self.frame = CGRectMake(0, 0, MIN(textSize.width + 20, maxWidth), textSize.height + 20);
        
        background.layer.cornerRadius = self.height / 2;
        
        [self addSubview:title];
        [self setLeadingConstraintToSubview:title withValue:10];
        [self setTrailingConstraintToSubview:title withValue:-10];
        [self setCenterYConstraintToSubview:title];
    }
    
    return self;
}

- (void)show
{
    [self fadeInWithCompletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
}

- (void)hide
{
    [self fadeOutWithCompletion:^{
        [self removeFromSuperview];
    }];
}

@end
