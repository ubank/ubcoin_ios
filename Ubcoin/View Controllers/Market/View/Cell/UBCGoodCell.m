//
//  UBCGoodCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodCell.h"
#import "UBCGoodDM.h"
#import "UBCSellerDM.h"
#import "UBCStarsView.h"
#import "UBCInfoLabel.h"

#import "Ubcoin-Swift.h"

@interface UBCGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBCInfoLabel *photoCount;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UBCStarsView *stars;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@end

@implementation UBCGoodCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.title.numberOfLines = 1;
    self.desc.numberOfLines = 1;
    self.containerView.cornerRadius = UBCConstant.defaultCornerRadius;
    [self.mainContainerView defaultShadow];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.background addVerticalGradientWithColors:@[(id)[UIColor clearColor].CGColor,
                                                     (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor]];
}

- (void)setContent:(UBCGoodDM *)content
{
    _content = content;
    
    self.title.text = [NSString stringWithFormat:@"%@ UBC", content.price.priceString];;
    self.desc.text = content.desc;
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.content.isFavorite ? @"B" : @"A"]];
    NSString *imageURL = [content.images firstObject];
    [self loadImageToFillWithURL:imageURL withDefaultImage:[UIImage imageNamed:@"item_default_image"] forImageView:self.icon];
    [self.stars showStars:content.seller.rating.unsignedIntegerValue];
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"1/%d", (int)content.images.count]];
}

#pragma mark - Actions

- (IBAction)toggleFavorite
{
    [self.content toggleFavorite];
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.content.isFavorite ? @"B" : @"A"]];
    [self.favoriteButton animateScaleWithAlphaWithTransform:0.4 withCompletion:nil];
}

@end
