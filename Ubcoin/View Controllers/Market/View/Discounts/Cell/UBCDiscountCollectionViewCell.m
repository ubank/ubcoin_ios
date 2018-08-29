//
//  UBCDiscountCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDiscountCollectionViewCell.h"
#import "UBCDiscountDM.h"

#import "Ubcoin-Swift.h"

@interface UBCDiscountCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet HUBLabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;

@end

@implementation UBCDiscountCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.cornerRadius = UBCConstant.defaultCornerRadius;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon setupContentModeFill];
    [self.background addVerticalGradientWithColors:@[(id)[UIColor clearColor].CGColor,
                                                    (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor]];
}

- (void)setContent:(UBCDiscountDM *)content
{
    self.title.text = content.title;
    self.desc.text = content.desc;
    [self loadImageToFillWithURL:content.imageURL withDefaultImage:content.image forImageView:self.icon];
}

@end
