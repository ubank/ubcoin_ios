//
//  HUBLabel.h
//  Halva
//
//  Created by Sergey Minakov on 24.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

typedef enum
{
    HUBLabelStyleCustom = 0,
    HUBLabelStyleDefaultTitle,
    HUBLabelStyleDefaultDescription,
    HUBLabelStylePromoTitle,
    HUBLabelStylePromoDescription,
    HUBLabelStyleHeader
} HUBLabelStyle;

IB_DESIGNABLE
@interface HUBLabel : UILabel

#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSInteger labelStyle;
#else
@property (assign, nonatomic) HUBLabelStyle labelStyle;
#endif

@property (strong, nonatomic) NSString *currencyText;

@property (assign, nonatomic, readonly) BOOL isCustomAttributedText;

- (instancetype)initWithStyle:(HUBLabelStyle)style;

@end
