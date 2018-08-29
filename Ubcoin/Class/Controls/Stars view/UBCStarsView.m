//
//  UBCStarsView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 09.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCStarsView.h"

@implementation UBCStarsView

- (void)showStars:(NSUInteger)starsCount
{
    [self removeAllSubviews];
    
    UIImage *image = [UIImage imageNamed:@"market_star"];
    CGFloat oryginY = (self.height - image.size.height) / 2;
    for (NSUInteger i = 0; i < starsCount; i++)
    {
        UIImageView *star = [[UIImageView alloc] initWithImage:image];
        star.originX = (image.size.width + 5) * i;
        star.originY = oryginY;
        [self addSubview:star];
    }
}

@end
