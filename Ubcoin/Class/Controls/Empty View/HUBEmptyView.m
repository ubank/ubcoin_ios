//
//  HUBEmptyView.m
//  uBank
//
//  Created by Alex Ostroushko on 25.07.17.
//  Copyright © 2017 uBank. All rights reserved.
//

#import "HUBEmptyView.h"

@implementation HUBEmptyView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.firstButton.hidden = YES;
    self.secondButton.hidden = YES;
}

- (void)setFirstActionBlock:(void (^)(void))firstActionBlock
{
    _firstActionBlock = firstActionBlock;
    
    self.firstButton.hidden = firstActionBlock == nil;
}

- (void)setSecondActionBlock:(void (^)(void))secondActionBlock
{
    _secondActionBlock = secondActionBlock;
    
    self.secondButton.hidden = secondActionBlock == nil;
}

- (IBAction)firstButtonPressed
{
    if (self.firstActionBlock)
    {
        self.firstActionBlock();
    }
}

- (IBAction)secondButtonPresed
{
    if (self.secondActionBlock)
    {
        self.secondActionBlock();
    }
}

@end
