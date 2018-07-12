//
//  UBCFavouriteCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCFavouriteCell.h"
#import "UBCStarsView.h"
#import "UBCGoodDM.h"

@interface UBCFavouriteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBCStarsView *stars;

@end

@implementation UBCFavouriteCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.icon.cornerRadius = 10;
    self.title.numberOfLines = 1;
    self.desc.numberOfLines = 1;
    self.desc.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
}

- (void)setContent:(UBCGoodDM *)content
{
    _content = content;
    
    self.title.text = content.title;
    self.desc.text = content.desc;
    NSString *imageURL = [content.images firstObject];
    [self loadImageWithURL:imageURL withDefaultImage:nil forImageView:self.icon];
    [self.stars showStars:content.seller.rating.unsignedIntegerValue];
}

@end
