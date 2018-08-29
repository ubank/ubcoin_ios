//
//  UBSectionHeaderView.m
//  uBank
//
//  Created by Alex Ostroushko on 30/05/16.
//  Copyright © 2016 uBank. All rights reserved.
//

#import "UBSectionHeaderView.h"

@implementation UBSectionHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.background.backgroundColor = UIColor.clearColor;
    
    self.title.textColor = UBColor.descColor;
    self.title.font = UBFont.descFont;
}

@end
