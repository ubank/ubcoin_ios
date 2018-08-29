//
//  UBAlertWindow.m
//  Halva
//
//  Created by Aidar on 16.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBAlertWindow.h"

#import "Ubcoin-Swift.h"

@interface UBAlertWindow ()

@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UBButton *button;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsStackViewHeightConstant;

@property (copy, nonatomic) void (^additionalActionBlock)(NSInteger index);

@end


@implementation UBAlertWindow

+ (instancetype)showAlertWindowWithTitle:(NSString *)title
                                    desc:(NSString *)desc
                                   image:(UIImage *)image
{
    UBAlertWindow *alert = self.show;
    
    alert.title.text = title;
    alert.desc.text = desc;
    alert.button.image = image;
    
    [alert forceHeightUpdate];
    
    return alert;
}

+ (instancetype)showAlertWindowWithTitle:(NSString *)title
                                    desc:(NSString *)desc
                                   image:(UIImage *)image
                        buttonApplyTitle:(NSString *)buttonApplyTitle
                       buttonCancelTitle:(NSString *)buttonCancelTitle
                     withCompletionBlock:(additionalActionBlock)completion
{
    UBAlertWindow *alert = [self showAlertWindowWithTitle:title desc:desc image:image];
    
    alert.buttonsStackViewHeightConstant.constant = UBCConstant.actionButtonHeight;
    [alert.buttonsStackView addTopSeparator];
    
    if (buttonApplyTitle.isNotEmpty)
    {
        UBButton *leftButton = UBButton.new;
        leftButton.title = buttonApplyTitle;
        leftButton.titleColor = UBGRAY_COLOR;
        leftButton.tag = CANCEL_INDEX + 1;
        [leftButton addTarget:alert action:@selector(additionalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [alert.buttonsStackView addArrangedSubview:leftButton];
    }
    
    if (buttonCancelTitle.isNotEmpty)
    {
        UBButton *rightButton = UBButton.new;
        rightButton.title = buttonCancelTitle;
        rightButton.titleColor = RED_COLOR;
        rightButton.tag = CANCEL_INDEX;
        [rightButton addTarget:alert action:@selector(additionalButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [alert.buttonsStackView addArrangedSubview:rightButton];
    }
    
    alert.additionalActionBlock = completion;
    
    [alert forceHeightUpdate];
    
    return alert;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.closeButtonHidden = YES;
    self.desc.font = UBFont.titleFont;
    self.desc.textColor = UBColor.descColor;
}

#pragma mark - Action

- (IBAction)buttonTapped
{
    [self hideWithCompletion:self.hideCompletionBlock];
}

- (void)additionalButtonTapped:(UBButton *)button
{
    if (self.additionalActionBlock)
    {
        self.additionalActionBlock(button.tag);
    }
    
    [self buttonTapped];
}

@end
