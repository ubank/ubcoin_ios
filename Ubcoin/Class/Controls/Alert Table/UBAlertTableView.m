//
//  UBAlertTableView.m
//  uBank
//
//  Created by ravil on 7/9/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

#import "UBAlertTableView.h"

@interface UBAlertTableView () <UBDefaultTableViewDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UBDefaultTableView *tableView;

@property (strong, nonatomic) NSArray *content;

@end


@implementation UBAlertTableView

#pragma mark - Init Methods

+ (instancetype)showWithContent:(NSArray<UBTableViewSectionData *> *)content title:(NSString *)title
{
    UBAlertTableView *alertTableView = self.new;
    
    [alertTableView.tableView updateWithSectionsData:content];
    alertTableView.titleLabel.text = title;
    
    [alertTableView showAlertTableView];
    
    return alertTableView;
}

- (instancetype)init
{
    self = super.init;
    
    if (self)
    {
        self.background = UIImageView.new;
        [self addSubview:self.background];
        [self addConstraintsToFillSubview:self.background];
        
        self.titleLabel = UILabel.new;
        self.titleLabel.font = UBFont.promoTitleFont;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColor.whiteColor;
        [self addSubview:self.titleLabel];
        [self setCenterXConstraintToSubview:self.titleLabel];
        [self setTopConstraintToSubview:self.titleLabel withValue:0];
        
        self.contentView = UIView.new;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.contentView];
        [self setLeadingConstraintToSubview:self.contentView withValue:0];
        [self setTrailingConstraintToSubview:self.contentView withValue:0];
        [self setBottomConstraintToSubview:self.contentView withValue:0];
        
        self.tableView = UBDefaultTableView.new;
        self.tableView.actionDelegate = self;
        [self.contentView addSubview:self.tableView];
        [self.contentView addConstraintsToFillSubview:self.tableView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.background addDefaultGradient];
}

#pragma mark - Action Methods

- (void)showAlertTableView
{
    CGFloat maxHeight = self.tableView.contentHeight;
    CGFloat contentHeight = DEFAULT_CELL_HEIGHT * 4.5;

    [self.contentView setHeightConstraintWithValue:MIN(maxHeight, contentHeight)];
    
    [self layoutIfNeeded];
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    [window endEditing:YES];
    
    self.background.alpha = 0;
    self.titleLabel.alpha = 0;
    
    self.tableView.scrollEnabled = self.tableView.height >= contentHeight;
    
    [window addSubview:self];
    [window addConstraintsToFillSubview:self];
    
    [self layoutIfNeeded];
    
    [self setTopConstraintToSubview:self.titleLabel withValue:self.height];
    [self setBottomConstraintToSubview:self.contentView withValue:self.contentView.height];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setTopConstraintToSubview:self.titleLabel withValue:(self.height - self.contentView.height) / 2];
        [self setBottomConstraintToSubview:self.contentView withValue:0];

        self.titleLabel.alpha = 1;
        self.background.alpha = 0.9;

        [self layoutIfNeeded];
    }];
}

- (void)hideAlertTableView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottomConstraintToSubview:self.contentView withValue:self.contentView.height];
        self.titleLabel.alpha = 0;
        self.background.alpha = 0;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideAlertTableView];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    if (self.dataSelected)
    {
        self.dataSelected(data);
    }
    
    [self hideAlertTableView];
}

@end
