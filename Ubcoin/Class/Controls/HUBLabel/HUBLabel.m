//
//  HUBLabel.m
//  Halva
//
//  Created by Sergey Minakov on 24.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBLabel.h"

@implementation HUBLabel

- (instancetype)initWithStyle:(HUBLabelStyle)style
{
    self = [self initWithFrame:CGRectZero];
    
    if (self)
    {
        self.labelStyle = style;
    }
    
    return self;
}

- (void)setLabelStyle:(HUBLabelStyle)labelStyle
{
    UIColor *color = self.textColor;
    
    [self applyStyle:labelStyle];
    
    // Hack to save Xib's Label Color
    // `Default` color is Black so we check it beeing the current one
    // to use styled or the one we set
    if (![color isEqual:UIColor.blackColor])
    {
        self.textColor = color;
    }
}

#pragma mark - Private Styling

- (void)applyStyle:(HUBLabelStyle)style
{
    switch (style)
    {
        case HUBLabelStyleCustom:
            return;
        case HUBLabelStyleDefaultTitle:
            self.textColor = UBColor.titleColor;
            self.font = UBFont.titleFont;
            break;
        case HUBLabelStyleDefaultDescription:
            self.textColor = UBColor.descColor;
            self.font = UBFont.descFont;
            break;
        case HUBLabelStylePromoTitle:
            self.textColor = UBColor.titleColor;
            self.font = UBFont.promoTitleFont;
            break;
        case HUBLabelStylePromoDescription:
            self.textColor = UBColor.titleColor;
            self.font = [UIFont systemFontOfSize:19 weight:UIFontWeightRegular];
            break;
        case HUBLabelStyleHeader:
            self.textColor = UBColor.titleColor;
            self.font = DEFAULT_HEADER_FONT;
            break;
    }
    
    self.numberOfLines = 0;
}

#pragma mark - IBDesignable

- (void)prepareForInterfaceBuilder
{
    self.labelStyle = self.labelStyle;
}

#pragma mark - Setters

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    _isCustomAttributedText = attributedText != nil;
}

- (void)setCurrencyText:(NSString *)text
{
    if (text)
    {
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        const char * c = [text cStringUsingEncoding:NSUTF8StringEncoding];
        if ([numbers characterIsMember:c[strlen(c) - 1]])
        {
            text = [text stringByAppendingFormat:@" ₽"];
        }
    }
    
    [super setText:text];
}

@end
