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

@property (strong, nonatomic) UBCStarsView *stars;

@end

@implementation UBCFavouriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.icon.cornerRadius = 10;
        self.iconWidth = 75;
        self.iconHeight = 75;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.iconContentModeSetted = YES;
        
        self.title.numberOfLines = 1;
        self.desc.numberOfLines = 1;
        self.desc.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        
        self.stars = UBCStarsView.new;
        [self.stars setHeightConstraintWithValue:30];
        [self.leftStackView addArrangedSubview:self.stars];
    }
    
    return self;
}

- (void)setRowData:(UBTableViewRowData *)rowData
{
    [super setRowData:rowData];
    
    UBCGoodDM *content = rowData.data;
    [self.stars showStars:content.seller.rating.unsignedIntegerValue];
}

@end
