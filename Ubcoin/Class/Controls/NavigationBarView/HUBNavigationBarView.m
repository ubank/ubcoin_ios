//
//  HUBStoresNavigationBar.m
//  Halva
//
//  Created by Александр Макшов on 19.02.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBNavigationBarView.h"

@interface HUBNavigationBarView ()

@property (weak, nonatomic) IBOutlet UIView *container;

@end


@implementation HUBNavigationBarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backButton.image = [[UIImage imageNamed:@"navbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self setHeightConstraintWithValue:NAVBAR_HEIGHT];
}

- (IBAction)exit:(id)sender
{
    if (self.exitActionBlock)
    {
        self.exitActionBlock();
    }
}

- (void)handleScrollOffset:(CGFloat)offset
{
    CGFloat coef = offset / 45;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:coef];
    
    [self setIsTransparent:coef <= 0.6];
}

- (void)setIsTransparent:(BOOL)isTransparent
{
    _isTransparent = isTransparent;
    
    self.titleLabel.textColor = isTransparent ? UIColor.whiteColor : UBColor.navigationTitleColor;
    self.backButton.tintColor = isTransparent ? UIColor.whiteColor : UBColor.navigationTintColor;
}

@end
