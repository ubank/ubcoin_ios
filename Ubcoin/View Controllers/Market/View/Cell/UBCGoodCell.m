//
//  UBCGoodCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodCell.h"
#import "UBCGoodDM.h"

@interface UBCGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;

@end

@implementation UBCGoodCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.cornerRadius = DEFAULT_CORNER_RADIUS;
}

- (void)setContent:(UBCGoodDM *)content
{
    self.title.text = content.title;
    self.desc.text = content.desc;
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.content.isFavorite ? @"B" : @"A"]];
    NSString *imageURL = [content.images firstObject];
    [self loadImageWithURL:imageURL withDefaultImage:nil forImageView:self.icon];
}

#pragma mark - Actions

- (IBAction)toggleFavorite
{
    [self.content toggleFavorite];
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.content.isFavorite ? @"B" : @"A"]];
    [self.favoriteButton animateScaleWithAlphaWithTransform:0.4 withCompletion:nil];
}

@end
