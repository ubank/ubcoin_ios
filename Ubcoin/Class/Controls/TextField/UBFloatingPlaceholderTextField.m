//
//  UBFloatingPlaceholderTextField.m
//  uBank
//
//  Created by RAVIL on 7/24/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import "UBFloatingPlaceholderTextField.h"

@interface UBFloatingPlaceholderTextField ()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end


@implementation UBFloatingPlaceholderTextField

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self defaultSetup];
    }
    
    return self;
}

- (instancetype)init
{
    self = super.init;
    
    if (self)
    {
        [self defaultSetup];
    }
    
    return self;
}

- (void)defaultSetup
{
    self.backgroundColor = UIColor.clearColor;
    self.font = UBFont.fieldFont;
    self.textColor = UBColor.textFieldColor;
    
    self.line = UIView.new;
    self.line.backgroundColor = UBColor.separatorColor;
    [self addSubview:self.line];

    [self.line setHeightConstraintWithValue:1.5];
    [self setLeadingConstraintToSubview:self.line withValue:0];
    [self setTrailingConstraintToSubview:self.line withValue:0];
    [self setBottomConstraintToSubview:self.line withValue:0];
    
    self.placeholderLabel = UILabel.new;
    self.placeholderLabel.backgroundColor = UIColor.clearColor;
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = self.textColor;
    self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.placeholderLabel];
    [self setLeadingConstraintToSubview:self.placeholderLabel withValue:0];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textFieldDidBeginEditing:)
                                               name:UITextFieldTextDidBeginEditingNotification
                                             object:self];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(textFieldDidEndEditing:)
                                               name:UITextFieldTextDidEndEditingNotification
                                             object:self];
    
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:nil];
    
    self.placeholderLabel.text = placeholder;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self movePlaceholder:self.text.length != 0 || self.isFirstResponder animated:NO];
}

#pragma mark - Show Methods

- (void)movePlaceholder:(BOOL)active animated:(BOOL)animated
{
    if (!self.placeholderLabel.superview)
    {
        return;
    }
    
    self.placeholderLabel.font = active ? UBFont.descFont : self.font;
    
    [self setTopConstraintToSubview:self.placeholderLabel withValue:active ? 5 : (self.height - self.font.lineHeight) / 2];
    
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Text Field Methods

- (void)textFieldDidBeginEditing:(NSNotification *)notification
{
    if (notification.object == self)
    {
        [self movePlaceholder:YES animated:YES];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *)notification
{
    if (notification.object == self && self.text.length == 0)
    {
        [self movePlaceholder:NO animated:YES];
    }
}

#pragma mark - Text Frame Methods

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.text.length != 0 || self.isFirstResponder)
    {
        bounds = [self editingRectForBounds:bounds];
    }
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    UIEdgeInsets currentInset = self.boundsEdge;
    
    currentInset.top = 21;
    
    return UIEdgeInsetsInsetRect(bounds, currentInset);
}

@end
