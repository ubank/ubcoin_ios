//
//  UBCGoodCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodCell.h"
#import "UBCGoodDM.h"
#import "UBCAuthorDM.h"
#import "UBCStarsView.h"
#import "UBCInfoLabel.h"

#import "Ubcoin-Swift.h"

@interface UBCGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBCInfoLabel *photoCount;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UBCStarsView *stars;

@end

@implementation UBCGoodCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.title.numberOfLines = 1;
    self.desc.numberOfLines = 1;
    self.cornerRadius = UBCConstant.defaultCornerRadius;
}

- (void)setContent:(UBCGoodDM *)content
{
    _content = content;
    
    self.title.text = content.title;
    self.desc.text = content.desc;
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.content.isFavorite ? @"B" : @"A"]];
    NSString *imageURL = [content.images firstObject];
    [self loadImageToFillWithURL:imageURL withDefaultImage:nil forImageView:self.icon];
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
