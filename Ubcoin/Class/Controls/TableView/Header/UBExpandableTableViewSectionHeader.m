//
//  UBExpandableTableViewSectionHeader.m
//  uBank
//
//  Created by Александр Макшов on 01.08.17.
//  Copyright © 2017 uBank. All rights reserved.
//

#import "UBExpandableTableViewSectionHeader.h"

@interface UBExpandableTableViewSectionHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end


@implementation UBExpandableTableViewSectionHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundView = UIView.new;
    self.backgroundView.backgroundColor = UBColor.backgroundColor;

    [self addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapRecognizer:)]];
}

- (void)moveArrowForStateOpened:(BOOL)isOpened
{
    self.rightArrow.transform = !isOpened ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
}

- (void)tapRecognizer:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.actionBlock)
        {
            self.actionBlock(self);
        }
    }
}

@end
