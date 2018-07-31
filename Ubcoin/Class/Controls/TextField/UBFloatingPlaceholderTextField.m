//
//  UBFloatingPlaceholderTextField.m
//  uBank
//
//  Created by RAVIL on 7/24/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import "UBFloatingPlaceholderTextField.h"

#define PLACEHOLDER_COLOR UBColor.descColor
#define TEXT_COLOR UBColor.titleColor

@interface UBFloatingPlaceholderTextField () {
    CGFloat duration;
}

@property (nonatomic, assign) CGRect originalFloatingLabelFrame;
@property (nonatomic, assign) CGRect originalHintLabelFrame;
@property (nonatomic, assign) CGRect originalPlaceholderLabelFrame;

@property (nonatomic, assign) CGRect offsetFloatingLabelFrame;
@property (nonatomic, assign) CGRect offsetHintLabelFrame;
@property (nonatomic, assign) CGRect offsetPlaceholderLabelFrame;

@property (nonatomic) UILabel * floatingLabel;
@property (nonatomic) UILabel * hintLabel;
@property (nonatomic) UILabel * placeholderLabel;
@property (nonatomic) UILabel * errorLabel;

@property (nonatomic) UIColor  * placeholderTextColor;
@property (nonatomic) UIColor  * colorOfText;
@property (nonatomic) NSString * cachedPlaceholder;
@property (nonatomic) BOOL isErrorState;
@property (nonatomic) BOOL isActive;

@end

@implementation UBFloatingPlaceholderTextField

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_defaultSetup];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_defaultSetup];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.placeholder = self.placeholder;
    self.text = self.text;
}

#pragma mark - SETUP

- (void) p_defaultSetup {
    
    self.backgroundColor = [UIColor clearColor];
    
    duration = 0.2f;
    self.spaceBetweenFloatingAndHint = 5.f;
    self.spaceBetweenFloatingAndText = 5.f;
    
    self.headerFont = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.font       = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    
    self.placeholderTextColor = PLACEHOLDER_COLOR;
    self.errorTextColor    = RED_COLOR;
    self.headerTextColor   = UBGRAY_COLOR;
    self.normalTextColor   = TEXT_COLOR;
    self.textColor         = TEXT_COLOR;
    
    [self p_setupNotifications];
    [self p_setupLabels];
}

- (void) p_setupNotifications {
    NSNotificationCenter *  center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textFieldDidBeginEditing:)
                   name:UITextFieldTextDidBeginEditingNotification object:self];
    [center addObserver:self selector:@selector(textFieldDidEndEditing:)
                   name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void) p_setupLabels {
    self.floatingLabel = [[UILabel alloc] init];
    self.floatingLabel.clipsToBounds = NO;
    self.floatingLabel.backgroundColor = [UIColor clearColor];
    self.floatingLabel.alpha = 0.f;
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.alpha = 0.f;
    [self.floatingLabel addSubview:self.hintLabel];

    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.errorLabel.hidden = YES;

    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = self.placeholderTextColor;
    [self addSubview:self.placeholderLabel];
}

#pragma mark - SETTERS

- (void) setErrorText:(NSString *)errorText {
    _errorText = errorText;
    self.errorLabel.text = [errorText uppercaseString];
}

- (void) setErrorTextColor:(UIColor *)errorTextColor {
    _errorTextColor = errorTextColor;
    self.errorLabel.textColor = errorTextColor;
}

- (void) setHeaderFont:(UIFont *)headerFont {
    _headerFont = headerFont;
    self.floatingLabel.font = headerFont;
    self.hintLabel.font = headerFont;
}

- (void) setHeaderTextColor:(UIColor *)headerTextColor {
    _headerTextColor = headerTextColor;
    self.floatingLabel.textColor = headerTextColor;
    self.hintLabel.textColor = headerTextColor;
}

- (void) setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    if (![textColor isEqual:self.errorTextColor]) {
        self.colorOfText = textColor;
    }
}

- (void) setHint:(NSString *)hint {
    _hint = hint;
    self.hintLabel.text = hint;
}

- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.cachedPlaceholder isEqualToString:aPlaceholder]) return;
    
    [super setPlaceholder:nil];
    
    self.cachedPlaceholder = aPlaceholder;
    
    self.floatingLabel.text = self.cachedPlaceholder;
    self.placeholderLabel.text = self.cachedPlaceholder;
}

- (void) setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    self.floatingLabel.font = placeholderFont;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self p_calculateFrames];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    UIColor *headerColor = editable ? self.headerTextColor : PLACEHOLDER_COLOR;
    self.hintLabel.textColor = headerColor;
    self.floatingLabel.textColor = headerColor;
    
    UIColor *currentColor = self.isErrorState ? self.errorTextColor : self.normalTextColor;
    self.textColor = editable ? currentColor : PLACEHOLDER_COLOR;
}

#pragma mark - HELP

- (BOOL) hasText {
    return self.text.length != 0;
}

- (CGSize) calculateSizeWithString:(NSString *)string font:(UIFont *)font {
    CGSize newSize = CGSizeZero;
    if (string.length != 0 && font) {
        NSAttributedString * attributedText =
        [[NSAttributedString alloc] initWithString:string
                                        attributes:@{NSFontAttributeName:font}];
        
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        newSize = (CGSize) {
            .width = ceil(rect.size.width),
            .height = ceil(rect.size.height)
        };
    }
    return newSize;
}

#pragma mark -

- (void) showError {
    if (self.errorText.length != 0) {
        self.isErrorState = YES;
        self.errorLabel.hidden = NO;
        self.textColor = self.errorTextColor;
    }
}

- (void) hideError {
    self.isErrorState = NO;
    self.errorLabel.hidden = YES;
    self.textColor = self.colorOfText;
}

#pragma mark -

- (void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        if (![[self.floatingLabel superview] isEqual:newSuperview]) {
            [newSuperview addSubview:self.floatingLabel];
            [newSuperview addSubview:self.errorLabel];
        }
    }
    else {
        [self.floatingLabel removeFromSuperview];
        [self.errorLabel removeFromSuperview];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self p_bringFloatingLabelToFront];
}

#pragma mark -

- (void) p_bringFloatingLabelToFront {
    UIView * superViewOfSelf = [self superview];
    UIView * superViewOfFloatingLabel = [self.floatingLabel superview];
    UIView * superViewOfErrorLabel = [self.errorLabel superview];
    if (superViewOfSelf) {
        if (superViewOfFloatingLabel && [superViewOfSelf isEqual:superViewOfFloatingLabel]) {
            [superViewOfFloatingLabel bringSubviewToFront:self.floatingLabel];
        }
        if (superViewOfErrorLabel && [superViewOfSelf isEqual:superViewOfErrorLabel]) {
            [superViewOfErrorLabel bringSubviewToFront:self.errorLabel];
        }
    }
}

- (void) p_calculateFrames {
    
    CGFloat height = self.frame.size.height;
    
    CGSize sizeOfFloatingLabel = [self calculateSizeWithString:self.cachedPlaceholder font:self.floatingLabel.font];
    CGSize sizeOfHintLabel     = [self calculateSizeWithString:self.hint font:self.hintLabel.font];
    CGSize sizeOfPlaceHolder   = [self calculateSizeWithString:self.cachedPlaceholder font:self.placeholderLabel.font];
    CGSize sizeOfError         = [self calculateSizeWithString:self.errorText font:self.errorLabel.font];
    
    CGFloat insetOfPlaceHolder = (height - sizeOfPlaceHolder.height)/2.f;
    CGFloat insetOfFloating    = (height - sizeOfFloatingLabel.height)/2.f;
    CGFloat insetOfCommon      = (height - sizeOfPlaceHolder.height - sizeOfFloatingLabel.height - self.spaceBetweenFloatingAndText)/2.f;
    
    self.originalFloatingLabelFrame = (CGRect) {
        self.frame.origin.x + self.boundsEdge.left,
        self.frame.origin.y + insetOfFloating,
        self.frame.size.width,
        sizeOfFloatingLabel.height
    };
    self.originalHintLabelFrame        = (CGRect) {sizeOfFloatingLabel.width, 0.f, sizeOfHintLabel};
    self.originalPlaceholderLabelFrame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, self.boundsEdge.left, 0, 0));
    
    self.floatingLabel.frame    = self.originalFloatingLabelFrame;
    self.hintLabel.frame        = self.originalHintLabelFrame;
    self.placeholderLabel.frame = self.originalPlaceholderLabelFrame;
    
    CGRect offsetFloatingFrame    = self.originalFloatingLabelFrame;
    offsetFloatingFrame.origin.y  = insetOfCommon;
    self.offsetFloatingLabelFrame = offsetFloatingFrame;
    
    self.offsetHintLabelFrame        = CGRectOffset(self.originalHintLabelFrame, self.spaceBetweenFloatingAndHint, 0.f);
    self.offsetPlaceholderLabelFrame = CGRectOffset(self.originalPlaceholderLabelFrame, 0.f, (insetOfPlaceHolder - insetOfCommon) * 2);
    
    self.errorLabel.frame = (CGRect){
        self.frame.origin.x + self.boundsEdge.left,
        self.frame.origin.y + height - insetOfCommon,
        self.frame.size.width - self.boundsEdge.left - self.boundsEdge.right,
        sizeOfError.height
    };
    
    [self p_checkForCurrentState];
}

- (void) p_checkForCurrentState {
    if (self.hasText || self.isFirstResponder) {
        [self showFloatingLabelWithAnimation:NO];
    }
    else {
        [self hideFloatingLabelWithAnimation:NO];
    }
    if (self.isErrorState) {
        [self showError];
    }
    else {
        [self hideError];
    }
}

#pragma mark - ANIMATIONS

- (void) showFloatingLabelWithAnimation:(BOOL)animation {
    
    self.hintLabel.alpha        = 0.f;
    self.floatingLabel.alpha    = 0.f;
    self.placeholderLabel.alpha = 0.f;
    
    void (^blockOfAnimation)(void) = ^{
        self.floatingLabel.alpha = 1.f;
        self.floatingLabel.frame = self.offsetFloatingLabelFrame;
        self.placeholderLabel.frame = self.offsetPlaceholderLabelFrame;
    };
    
    if (animation) {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:duration delay:0.f options:options animations:blockOfAnimation
                         completion:^(BOOL finished) {
                             self.isActive = YES;
                             [self showHintLabelWithAnimation:animation];
                         }];
    }
    else {
        self.isActive = YES;
        blockOfAnimation();
        [self showHintLabelWithAnimation:NO];
    }
}

- (void) showHintLabelWithAnimation:(BOOL)animation {
    
    void (^blockOfAnimation)(void) = ^{
        self.hintLabel.alpha = 1.f;
        self.hintLabel.frame = self.offsetHintLabelFrame;
    };
    if (animation) {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:duration delay:0.f options:options animations:blockOfAnimation completion:NULL];
    }
    else {
        blockOfAnimation();
    }
}

- (void) hideFloatingLabelWithAnimation:(BOOL)animation {
    
    void (^blockOfAnimation)(void) = ^{
        self.floatingLabel.alpha = 0.f;
        self.hintLabel.alpha = 0.f;
        self.placeholderLabel.alpha = 1.f;
        self.floatingLabel.frame = self.originalFloatingLabelFrame;
        self.hintLabel.frame = self.originalHintLabelFrame;
        self.placeholderLabel.frame = self.originalPlaceholderLabelFrame;
    };
    
    if (animation) {
        UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn;
        [UIView animateWithDuration:duration delay:0.f options:options animations:blockOfAnimation completion:^(BOOL finished) {
            self.isActive = NO;
        }];
    }
    else {
        self.isActive = NO;
        blockOfAnimation();
    }
}

#pragma mark - TEXT FIELD OBSERVERS

- (void) textFieldDidBeginEditing:(NSNotification *)notification {
    if (!self.hasText || !self.isActive) {
        [self showFloatingLabelWithAnimation:YES];
    }
}

- (void) textFieldDidEndEditing:(NSNotification *)notification {
    if (!self.hasText) {
        [self hideFloatingLabelWithAnimation:YES];
    }
}

- (CGRect) textRectForBounds:(CGRect)bounds {
    CGRect newBounds = UIEdgeInsetsInsetRect(bounds, self.boundsEdge);
    if (self.hasText || self.isFirstResponder) {
        newBounds = [self editingRectForBounds:bounds];
    }
    return newBounds;
}

- (CGRect) editingRectForBounds:(CGRect)bounds {
    UIEdgeInsets currentInset = self.boundsEdge;
    currentInset.top = self.offsetPlaceholderLabelFrame.origin.y;
    return UIEdgeInsetsInsetRect(bounds, currentInset);
}

@end
