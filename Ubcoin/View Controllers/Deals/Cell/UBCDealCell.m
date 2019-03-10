//
//  UBCDealCell.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealCell.h"

@interface UBCDealCell()

//@property (strong, nonatomic) UIView *badgeView;

@end

@implementation UBCDealCell

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
        
        self.distanceLabel = UBCInfoLabel.new;
        [self.icon addSubview:self.distanceLabel];
        [self.icon setBottomConstraintToSubview:self.distanceLabel withValue:-2];
        [self.icon setCenterXConstraintToSubview:self.distanceLabel];
        
        self.desc.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        
        self.info = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultDescription];
        [self.leftStackView addArrangedSubview:self.info];
    }
    
    return self;
}

- (void)setLocation:(CLLocation *)location
{
    NSString *distance = [UBLocationManager distanceStringFromMeAndCoordinates:location.coordinate];
    self.distanceLabel.hidden = !distance.isNotEmpty || !location;
    [self.distanceLabel setupWithImage:[UIImage imageNamed:@"market_location"]
                               andText:distance];
}

@end
