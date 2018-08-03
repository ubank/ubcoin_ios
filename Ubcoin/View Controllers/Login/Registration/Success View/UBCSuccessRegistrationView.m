//
//  UBCSuccessRegistrationView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 01.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSuccessRegistrationView.h"

@interface UBCSuccessRegistrationView ()

@property (strong, nonatomic) IBOutlet HUBLabel *infoDesc;

@end

@implementation UBCSuccessRegistrationView

+ (void)showWithEmail:(NSString *)email
{
    UBCSuccessRegistrationView *view = UBCSuccessRegistrationView.loadFromXib;
    [view setEmail:email];
    [view show];
}

- (void)setEmail:(NSString *)email
{
    if (email)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:UBLocalizedString(@"str_we_sent_verification_letter", nil)];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:email attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold]}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:UBLocalizedString(@"str_click_link_to_get_started", nil)]];
        self.infoDesc.attributedText = text;
    }
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
