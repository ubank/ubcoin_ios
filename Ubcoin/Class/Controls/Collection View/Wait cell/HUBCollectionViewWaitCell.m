//
//  HUBCollectionViewCell.m
//  Halva
//
//  Created by Александр Макшов on 25.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBCollectionViewWaitCell.h"

#import "Ubcoin-Swift.h"

@implementation HUBCollectionViewWaitCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = UBCConstant.cornerRadius;
    self.backgroundColor = UIColor.whiteColor;
}

@end
