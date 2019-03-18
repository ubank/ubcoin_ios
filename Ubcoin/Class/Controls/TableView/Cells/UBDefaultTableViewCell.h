//
//  UBDefaultTableViewCell.h
//  Halva
//
//  Created by Aidar on 17.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#define default_icon_width 48

@interface UBDefaultTableViewCell : UBTableViewCell

@property (strong, nonatomic, readonly) UIStackView *horizontalStackView;

@property (strong, nonatomic) UIView *badgeView;

@property (strong, nonatomic, readonly) UIImageView *icon;

@property (strong, nonatomic) UIStackView *leftStackView;

@property (strong, nonatomic, readonly) HUBLabel *title;
@property (strong, nonatomic, readonly) HUBLabel *desc;

@property (strong, nonatomic, readonly) HUBLabel *rightTitle;
@property (strong, nonatomic, readonly) HUBLabel *rightDesc;

@property (strong, nonatomic, readonly) UIImageView *rightIcon;

@property (strong, nonatomic) UBTableViewRowData *rowData;

@property (assign, nonatomic) CGFloat iconWidth;
@property (assign, nonatomic) CGFloat iconHeight;
@property (assign, nonatomic) CGFloat leftIndent;
@property (assign, nonatomic) CGFloat rightIndent;

@property (assign, nonatomic) BOOL iconContentModeSetted;

@property (assign, nonatomic, readonly) CGFloat cellHeight;

+ (instancetype)sizingCell;

@end
