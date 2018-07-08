//
//  UBDefaultTableViewCell.m
//  Halva
//
//  Created by Aidar on 17.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBDefaultTableViewCell.h"

#import "Ubcoin-Swift.h"

#define default_horizontal_spacing 10
#define default_vertical_spacing 5
#define default_vertical_offset 10

@interface UBDefaultTableViewCell ()

@property (strong, nonatomic) UIStackView *horizontalStackView;

@property (strong, nonatomic, readwrite) UIImageView *icon;

@property (strong, nonatomic) UIStackView *leftStackView;
@property (strong, nonatomic, readwrite) HUBLabel *title;
@property (strong, nonatomic, readwrite) HUBLabel *desc;

@property (strong, nonatomic) UIStackView *rightStackView;
@property (strong, nonatomic, readwrite) HUBLabel *rightTitle;
@property (strong, nonatomic, readwrite) HUBLabel *rightDesc;

@property (strong, nonatomic, readwrite) UIImageView *rightIcon;

@end


@implementation UBDefaultTableViewCell

#pragma mark - Init Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = UIColor.whiteColor;
        
        [self setupViews];
        
        self.iconWidth = default_icon_width;
        self.iconHeight = default_icon_width;
        self.leftIndent = UBCConstant.inset;
        self.rightIndent = UBCConstant.inset;
        
        self.separatorAlignmentView = self.title;
    }
    
    return self;
}

- (void)setupViews
{
    self.icon = UIImageView.new;
    self.icon.contentMode = UIViewContentModeCenter;
    
    self.title = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultTitle];
    self.desc = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultDescription];
    
    self.leftStackView = [UIStackView.alloc initWithArrangedSubviews:@[self.title, self.desc]];
    self.leftStackView.axis = UILayoutConstraintAxisVertical;
    self.leftStackView.distribution = UIStackViewDistributionFill;
    self.leftStackView.alignment = UIStackViewAlignmentFill;
    self.leftStackView.spacing = default_vertical_spacing;
    
    self.rightTitle = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultTitle];
    self.rightTitle.textAlignment = NSTextAlignmentRight;
    self.rightDesc = [HUBLabel.alloc initWithStyle:HUBLabelStyleDefaultDescription];
    self.rightDesc.textAlignment = NSTextAlignmentRight;
    
    self.rightStackView = [UIStackView.alloc initWithArrangedSubviews:@[self.rightTitle, self.rightDesc]];
    self.rightStackView.axis = UILayoutConstraintAxisVertical;
    self.rightStackView.distribution = UIStackViewDistributionFill;
    self.rightStackView.alignment = UIStackViewAlignmentFill;
    self.rightStackView.spacing = default_vertical_spacing;
    
    self.rightIcon = UIImageView.new;
    self.rightIcon.contentMode = UIViewContentModeCenter;
    
    self.horizontalStackView = [UIStackView.alloc initWithArrangedSubviews:@[self.icon, self.leftStackView, self.rightStackView, self.rightIcon]];
    self.horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    self.horizontalStackView.distribution = UIStackViewDistributionFill;
    self.horizontalStackView.alignment = UIStackViewAlignmentCenter;
    self.horizontalStackView.spacing = default_horizontal_spacing;
    [self.contentView addSubview:self.horizontalStackView];
    [self.contentView setCenterYConstraintToSubview:self.horizontalStackView];
    
    [self.rightIcon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightTitle setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightDesc setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.iconContentModeSetted)
    {
        [self.icon setupContentModeFit];
    }
}

#pragma mark - Data Methods

- (void)setRowData:(UBTableViewRowData *)rowData
{
    _rowData = rowData;
    
    self.icon.image = nil;
    self.title.text = nil;
    self.desc.text = nil;
    self.rightTitle.text = nil;
    self.rightDesc.text = nil;
    self.rightIcon.image = nil;
    
    self.accessoryView = nil;
    
    self.icon.backgroundColor = UIColor.clearColor;
    if (rowData.iconBackgroundColor)
    {
        self.icon.backgroundColor = rowData.iconBackgroundColor;
    }
    
    [self.icon forceLayout];
    
    [self loadImageWithURL:rowData.iconURL withDefaultImage:rowData.icon forImageView:self.icon];
    
    if (rowData.attributedTitle)
    {
        self.title.attributedText = rowData.attributedTitle;
    }
    else if (rowData.title.isNotEmpty)
    {
        self.title.text = rowData.title;
    }
    
    if (rowData.attributedDesc)
    {
        self.desc.attributedText = rowData.attributedDesc;
    }
    else if (rowData.desc.isNotEmpty)
    {
        self.desc.text = rowData.desc;
    }
    
    if (rowData.attributedRightTitle)
    {
        self.rightTitle.attributedText = rowData.attributedRightTitle;
    }
    else if (rowData.rightTitle.isNotEmpty)
    {
        self.rightTitle.text = rowData.rightTitle;
    }
    
    if (rowData.attributedRightDesc)
    {
        self.rightDesc.attributedText = rowData.attributedRightDesc;
    }
    else if (rowData.rightDesc.isNotEmpty)
    {
        self.rightDesc.text = rowData.rightDesc;
    }
    
    if (rowData.rightIcon)
    {
        self.rightIcon.image = rowData.rightIcon;
    }
    
    self.accessoryType = rowData.accessoryType;
    self.separatorType = rowData.separatorType;
    self.showHighlighted = !rowData.disableHighlight;
    
    [self hideViews];
}

- (void)hideViews
{
    self.icon.hidden = !self.icon.image && !self.rowData.iconURL;
    self.title.hidden = !self.title.text.isNotEmpty;
    self.desc.hidden = !self.desc.text.isNotEmpty;
    self.leftStackView.hidden = self.title.hidden && self.desc.hidden;
    self.rightTitle.hidden = !self.rightTitle.text.isNotEmpty;
    self.rightDesc.hidden = !self.rightDesc.text.isNotEmpty;
    self.rightStackView.hidden = self.rightTitle.hidden && self.rightDesc.hidden;
    self.rightIcon.hidden = !self.rightIcon.image;
}

#pragma mark - Setter Methods

- (void)setLeftIndent:(CGFloat)leftIndent
{
    _leftIndent = leftIndent;
    
    [self.contentView setLeadingConstraintToSubview:self.horizontalStackView withValue:_leftIndent];
}

- (void)setRightIndent:(CGFloat)rightIndent
{
    _rightIndent = rightIndent;
    
    [self.contentView setTrailingConstraintToSubview:self.horizontalStackView withValue:-_rightIndent];
}

- (void)setIconWidth:(CGFloat)iconWidth
{
    _iconWidth = iconWidth;
    
    [self.icon setWidthConstraintWithValue:_iconWidth];
}

- (void)setIconHeight:(CGFloat)iconHeight
{
    _iconHeight = iconHeight;
    
    [self.icon setHeightConstraintWithValue:_iconHeight];
}

#pragma mark - Size Methods

+ (instancetype)sizingCell
{
    static UBDefaultTableViewCell *sizingCell;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sizingCell = [self.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sizingCell"];
        sizingCell.width = SCREEN_WIDTH;
    });
    
    return sizingCell;
}

- (CGFloat)cellHeight
{
    //Костыль над iOS rightIndent (который равен 8) и исправляется на 15 очень поздно
    self.rightIndent = UBCConstant.inset + (self.accessoryView ? 7 : 0);
    
    [self forceLayout];
    
    [self.horizontalStackView forceHeightUpdate];
    
    CGFloat height = self.horizontalStackView.height + default_vertical_offset * 2;
    
    return MAX(UBCConstant.cellHeight, height);
}

@end
