//
//  HUBCollectionViewCell.m
//  Halva
//
//  Created by Александр Макшов on 25.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBCollectionViewWaitCell.h"

@implementation HUBCollectionViewWaitCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
    self.backgroundColor = UIColor.whiteColor;
}

@end
