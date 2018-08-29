//
//  UBCollectionViewSwitchContent.m
//  uBank
//
//  Created by RAVIL on 4/15/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import "UBCollectionViewSwitchContent.h"

@interface UBCollectionViewSwitchContent ()

@property (nonatomic) NSString *titleOfCell;

@property (strong, nonatomic, readwrite) NSAttributedString *attributedStringOfTitle;
@property (strong, nonatomic, readwrite) UIView *contentView;

@end

@implementation UBCollectionViewSwitchContent

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view
{
    self = [super init];
    
    if (self)
    {
        self.titleOfCell = title;
        self.contentView = view;
        [self initAttributedString];
    }
    
    return self;
}

- (void)initAttributedString
{
    if (!self.titleOfCell)
    {
        self.titleOfCell = @"";
    }
    
    self.attributedStringOfTitle = [[NSAttributedString alloc] initWithString:self.titleOfCell
                                                                   attributes:@{NSFontAttributeName : UBFont.titleFont,
                                                                                NSForegroundColorAttributeName : UBLACK_COLOR}];
}

- (NSAttributedString *)highlightedAttributedString
{
    return [[NSAttributedString alloc] initWithString:self.titleOfCell
                                           attributes:@{NSFontAttributeName : UBFont.titleFont,
                                                        NSForegroundColorAttributeName: UBGRAY_COLOR}];
}

@end
