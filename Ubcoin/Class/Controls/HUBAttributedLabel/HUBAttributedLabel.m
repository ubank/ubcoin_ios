//
//  HUBAttributedLabel.m
//  Halva
//
//  Created by Sergey Minakov on 23.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBAttributedLabel.h"

@interface HUBAttributedLabel ()

@property (copy, nonatomic) NSString *rawText;

@end

@implementation HUBAttributedLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
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

- (void)setup
{
    self.numberOfLines = 0;
    self.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    NSDictionary *linkAttributes = @{
                                     NSForegroundColorAttributeName : BROWN_COLOR,
                                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
                                    };
    
    NSDictionary *activeLinkAttributes = @{
                                     NSForegroundColorAttributeName : LIGHT_GRAY_COLOR2,
                                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
                                     };
    
    self.linkAttributes = linkAttributes;
    self.inactiveLinkAttributes = linkAttributes;
    self.activeLinkAttributes = activeLinkAttributes;
}

- (void)setText:(id)text
{
    if ([text isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString *)[text copy];
        self.rawText = string;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                       initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                       documentAttributes:nil
                                                       error:nil];
        
        [attributedString
         addAttributes:@{NSForegroundColorAttributeName : self.textColor,
                         NSFontAttributeName : self.font}
         range:NSMakeRange(0, attributedString.length)];
        
        text = attributedString;
        [super setText:text];
    }
    else if (!text ||
             [text isKindOfClass:[NSAttributedString class]])
    {
        [super setText:text];
    }
}

- (NSString *)text
{
    return self.rawText ?: [super text];
}

@end
