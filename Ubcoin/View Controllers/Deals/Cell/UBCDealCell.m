//
//  UBCDealCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealCell.h"

@implementation UBCDealCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.icon.cornerRadius = 10;
        self.iconWidth = 75;
        self.iconHeight = 75;
        
        self.title.numberOfLines = 1;
        self.desc.numberOfLines = 1;
        self.desc.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        
        self.info = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultDescription];
        [self.leftStackView addArrangedSubview:self.info];
    }
    
    return self;
}

@end
