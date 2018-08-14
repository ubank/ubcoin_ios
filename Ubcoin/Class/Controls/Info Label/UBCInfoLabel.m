//
//  UBCInfoLabel.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCInfoLabel.h"

@implementation UBCInfoLabel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.numberOfLines = 1;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = UIColor.whiteColor;
    self.font = UBFont.descFont;
    self.cornerRadius = 5;
    
    [self setHeightConstraintWithValue:21];
}

- (void)setupWithImage:(UIImage *)image andText:(NSString *)text
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString notEmptyString:text]];
    if (image)
    {
        [attString insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
        
        NSTextAttachment *textAttachment = NSTextAttachment.new;
        textAttachment.image = image;
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attString insertAttributedString:attrStringWithImage atIndex:0];
    }
    
    self.attributedText = attString;
    
    CGFloat width = attString.sizeWithAttributedString.width;
    [self setWidthConstraintWithValue:MAX(48, width + 18)];
}

@end
