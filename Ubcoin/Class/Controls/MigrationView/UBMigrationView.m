//
//  UBMigrationView.m
//  uBank
//
//  Created by RAVIL on 9/8/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import "UBMigrationView.h"

@interface UBMigrationView ()

@property (strong, nonatomic) UIView *circleView_1;
@property (strong, nonatomic) UIView *circleView_2;
@property (strong, nonatomic) UIView *circleView_3;
@property (strong, nonatomic) UIView *circleView_4;
@property (strong, nonatomic) UIView *circleView_5;

@property (strong, nonatomic) UIImageView *logo;

@end


@implementation UBMigrationView

#pragma mark - Init Methods

- (instancetype)initWithoutAnimationWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupViews];
        [self setupAnimations];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addDefaultGradient];
}

- (void)setupViews
{
    self.logo = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"main_halva_symbol"]];
    [self addSubview:self.logo];
    [self addConstraintsToCenterSubview:self.logo];
}

- (void)setupAnimations
{
    [self animateShape_1];
    [self animateShape_2];
    [self animateShape_3];
    [self animateShape_4];
    [self animateShape_5];
    
    [self animatelogo];
}

#pragma mark - Animate Methods

- (void)animateShape_1
{
    int radius = 100;
    
    if (!self.circleView_1)
    {
        self.circleView_1 = [self generateCircleViewWithRadious:radius withBorderWidth:3];
        
        [self addSubview:self.circleView_1];
    }
    
    __weak typeof(self) weakSelf = self;
    [self animateCircle:self.circleView_1 withDuration:1.25 endDuration:2.15 withDumping:2 withBeginScale:2 withEndScale:1 withEndAlpha:0.1 completion:^(BOOL finished) {
        [weakSelf animateShape_1];
    }];
}

- (void)animateShape_2
{
    int radius = 130;
    
    if (!self.circleView_2)
    {
        self.circleView_2 = [self generateCircleViewWithRadious:radius withBorderWidth:3];
        
        [self addSubview:self.circleView_2];
    }
    
    __weak typeof(self) weakSelf = self;
    [self animateCircle:self.circleView_2 withDuration:1.25 endDuration:2.15 withDumping:2 withBeginScale:2.2 withEndScale:1 withEndAlpha:0.35 completion:^(BOOL finished) {
        [weakSelf animateShape_2];
    }];
}

- (void)animateShape_3
{
    int radius = 160;
    
    if (!self.circleView_3)
    {
        self.circleView_3 = [self generateCircleViewWithRadious:radius withBorderWidth:3];
        
        [self addSubview:self.circleView_3];
    }
    
    __weak typeof(self) weakSelf = self;
    [self animateCircle:self.circleView_3 withDuration:1.25 endDuration:2.15 withDumping:2 withBeginScale:1.4 withEndScale:1 withEndAlpha:0.05 completion:^(BOOL finished) {
        [weakSelf animateShape_3];
    }];
}

- (void)animateShape_4
{
    int radius = 225;
    
    if (!self.circleView_4)
    {
        self.circleView_4 = [self generateCircleViewWithRadious:radius withBorderWidth:20];
        
        [self addSubview:self.circleView_4];
    }
    
    __weak typeof(self) weakSelf = self;
    [self animateCircle:self.circleView_4 withDuration:1.25 endDuration:2.15 withDumping:2 withBeginScale:0.5 withEndScale:0.5 withEndAlpha:0.30 completion:^(BOOL finished) {
        [weakSelf animateShape_4];
    }];
}

- (void)animateShape_5
{
    int radius = 310;
    
    if (!self.circleView_5)
    {
        self.circleView_5 = [self generateCircleViewWithRadious:radius withBorderWidth:45];
        
        [self addSubview:self.circleView_5];
    }
    
    __weak typeof(self) weakSelf = self;
    [self animateCircle:self.circleView_5 withDuration:1.25 endDuration:2.15 withDumping:2 withBeginScale:0.5 withEndScale:1 withEndAlpha:0.1 completion:^(BOOL finished) {
        [weakSelf animateShape_5];
    }];
}

- (UIView *)generateCircleViewWithRadious:(int)radius withBorderWidth:(float)borderWidth
{
    UIView *circle = UIView.new;
    
    circle.backgroundColor = UIColor.clearColor;
    circle.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    circle.center = self.center;
    circle.layer.cornerRadius = radius;
    circle.layer.borderWidth = borderWidth;
    circle.alpha = 0.3;
    circle.layer.borderColor = UIColor.whiteColor.CGColor;
    
    return circle;
}

- (void)animatelogo
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.75
                          delay:0
         usingSpringWithDamping:1.
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.logo.alpha = 0.15;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.75
                                               delay:0
                              usingSpringWithDamping:2.5
                               initialSpringVelocity:0
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              weakSelf.logo.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              [weakSelf animatelogo];
                                          }];
                     }];
}

- (void)animateCircle:(UIView *)circle withDuration:(float)duration endDuration:(float)endDuration withDumping:(float)dumping withBeginScale:(float)firstScale withEndScale:(float)endScale withEndAlpha:(float)endAlpha completion:(void (^)(BOOL finished))block
{
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:dumping
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         circle.transform = CGAffineTransformMakeScale(firstScale, firstScale);
                         circle.alpha = 0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:endDuration
                                               delay:0
                              usingSpringWithDamping:2.5
                               initialSpringVelocity:0
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              circle.transform = CGAffineTransformMakeScale(1, 1);
                                              circle.alpha = endAlpha;
                                          } completion:^(BOOL finished) {
                                              block(YES);
                                          }];
                     }];
}

@end
