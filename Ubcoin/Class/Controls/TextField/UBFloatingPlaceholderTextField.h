//
//  UBFloatingPlaceholderTextField.h
//  uBank
//
//  Created by RAVIL on 7/24/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBTextField.h"

@interface UBFloatingPlaceholderTextField : UBTextField

@property (nonatomic, assign) CGFloat spaceBetweenFloatingAndHint;
@property (nonatomic, assign) CGFloat spaceBetweenFloatingAndText;

@property (nonatomic, strong) UIFont   *headerFont;
@property (nonatomic, strong) UIFont   *placeholderFont;
@property (nonatomic, strong) UIColor  *headerTextColor;

@property (nonatomic, strong) NSString *hint;

@property (nonatomic, strong) NSString *errorText;
@property (nonatomic, strong) UIColor  *errorTextColor;

@property (nonatomic, strong) UIColor *normalTextColor;

@property (nonatomic, assign) BOOL editable;

- (void) showError;
- (void) hideError;

@end
