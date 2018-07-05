//
//  UBCollectionViewSwitchContent.h
//  uBank
//
//  Created by RAVIL on 4/15/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

@interface UBCollectionViewSwitchContent : NSObject

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic, readonly) NSAttributedString *attributedStringOfTitle;

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view;
- (NSAttributedString *)highlightedAttributedString;

@end
