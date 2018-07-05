//
//  UBTableHeaderView.m
//  Halva
//
//  Created by Aidar on 20.02.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBTableHeaderView.h"

@implementation UBTableHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.desc.font = UBFont.titleFont;
    self.desc.textColor = UBColor.descColor;
}

@end
