//
//  UBCDealCell.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBDefaultTableViewCell.h"
#import "UBCInfoLabel.h"

@interface UBCDealCell : UBDefaultTableViewCell

@property (strong, nonatomic) HUBLabel *info;
@property (strong, nonatomic) UBCInfoLabel *distanceLabel;

- (void)setLocation:(CLLocation *)location;

@end
