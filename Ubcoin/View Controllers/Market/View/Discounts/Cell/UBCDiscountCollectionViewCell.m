//
//  UBCDiscountCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDiscountCollectionViewCell.h"
#import "UBCDiscountDM.h"

@interface UBCDiscountCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;

@end

@implementation UBCDiscountCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.cornerRadius = DEFAULT_CORNER_RADIUS;
}

- (void)setContent:(UBCDiscountDM *)content
{
    self.title.text = content.title;
    self.desc.text = content.desc;
    [self loadImageWithURL:content.imageURL withDefaultImage:nil forImageView:self.icon];
}

@end
