//
//  UBScrollView.m
//  Halva
//
//  Created by Александр Макшов on 29.01.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBScrollView.h"

@interface HUBScrollView ()

@end

@implementation HUBScrollView

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
    return self.isSimultaneousGestureEnabled;
}

@end
