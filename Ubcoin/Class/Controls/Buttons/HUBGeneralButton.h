//
//  HUBGeneralButton.h
//  Halva
//
//  Created by Alex Ostroushko on 16.06.17.
//  Copyright © 2017 uBank. All rights reserved.
//

typedef enum
{
    HUBGeneralButtonTypeCustom,
    HUBGeneralButtonTypeWhite,
    HUBGeneralButtonTypeGreen,
    HUBGeneralButtonTypeGreenTitle,
    HUBGeneralButtonTypeSemitransparent,
    HUBGeneralButtonTypeWhiteWithBrownBorder,
    HUBGeneralButtonTypeWhiteWithRedTitle
} HUBGeneralButtonType;

IB_DESIGNABLE
@interface HUBGeneralButton : UIButton

@property (assign, nonatomic) IBInspectable BOOL roundCorners;

#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSInteger type;
#else
@property (assign, nonatomic) HUBGeneralButtonType type;
#endif

@end
