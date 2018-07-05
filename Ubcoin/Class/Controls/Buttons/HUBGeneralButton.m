//
//  HUBGeneralButton.m
//  Halva
//
//  Created by Alex Ostroushko on 16.06.17.
//  Copyright © 2017 uBank. All rights reserved.
//

#import "HUBGeneralButton.h"

@interface HUBGeneralButton ()

@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (strong, nonatomic) UIColor *highlightedBackgroundColor;

@end


@implementation HUBGeneralButton

#pragma mark - Init Methods

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.exclusiveTouch = YES;
    self.titleLabel.font = UBFont.buttonFont;
    
    self.roundCorners = YES;
}

#pragma mark - Setter Methods

- (void)setRoundCorners:(BOOL)roundCorners
{
    self.layer.cornerRadius = roundCorners ? BIG_CORNER_RADIUS : 0;
}

- (void)setType:(HUBGeneralButtonType)type
{
    self.layer.borderWidth = 0;
    
    switch (type)
    {
        case HUBGeneralButtonTypeWhite:
            self.titleColor = BROWN_COLOR;
            self.backgroundColor = UIColor.whiteColor;
            break;
            
        case HUBGeneralButtonTypeBrown:
            self.titleColor = UIColor.whiteColor;
            self.backgroundColor = BROWN_COLOR;
            break;
            
        case HUBGeneralButtonTypeSemitransparent:
            self.titleColor = UIColor.whiteColor;
            self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
            break;
            
        case HUBGeneralButtonTypeWhiteWithBrownBorder:
            self.titleColor = BROWN_COLOR;
            self.backgroundColor = UIColor.whiteColor;
            self.layer.borderColor = BROWN_COLOR.CGColor;
            self.layer.borderWidth = 1;
            break;
            
        case HUBGeneralButtonTypeBlue:
            self.titleColor = UIColor.whiteColor;
            self.backgroundColor = CHATBANK_COLOR;
            break;
            
        default:
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.defaultBackgroundColor = backgroundColor;
    
    if ([backgroundColor isEqual:UIColor.whiteColor])
    {
        self.highlightedBackgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    else
    {
        self.highlightedBackgroundColor = [backgroundColor colorWithBrightness:0.8];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.titleLabel.alpha = self.highlighted ? 0.5 : 1;
    self.imageView.alpha = self.highlighted ? 0.5 : 1;
    
    UIColor *backgroundColor = self.highlighted ? self.highlightedBackgroundColor : self.defaultBackgroundColor;
    
    [super setBackgroundColor:backgroundColor];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title.uppercaseString forState:state];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.alpha = enabled ? 1 : 0.5;
}

#pragma mark - IBDesignable

- (void)prepareForInterfaceBuilder
{
    [self setType:self.type];
}

@end
