//
//  UBTableView.m
//  uBank
//
//  Created by Ravil on 6/10/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

#import "UBTableView.h"

@interface UBTableView () <UITableViewDelegate>

@property (strong, nonatomic) UIView *footerBackground;

@property (weak, nonatomic) id<UITableViewDelegate> internalDelegate;
@property (copy, nonatomic) void (^actionBlockOfRefreshControll)(void);
@property (strong, nonatomic, readwrite) UIRefreshControl *refreshControll;
@property (assign, nonatomic) BOOL disableContentOffsetChange;

@property (strong, nonatomic, readwrite) HUBEmptyView *emptyView;

@end

@implementation UBTableView

- (void)dealloc
{
    if (self.footerBackground)
    {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self setupObservers];
    [self setupEmptyView];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        self.cellLayoutMarginsFollowReadableWidth = NO;
        
        [self setupObservers];
        [self setupEmptyView];
    }
    
    return self;
}

- (void)setupObservers
{
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification  
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
}

- (void)setupEmptyView
{
    self.emptyView = [HUBEmptyView loadFromXib];
    self.emptyView.hidden = YES;
    [self addSubview:self.emptyView];
    [self addConstraintsForScrollToFillSubview:self.emptyView];
}

#pragma mark -

- (CGFloat)contentHeight
{
    CGFloat height = 0;
    if (self.dataSource)
    {
        NSUInteger sections = 1;
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        {
            sections = [self.dataSource numberOfSectionsInTableView:self];
        }
        if (sections > 0)
        {
            NSUInteger row = [self.dataSource tableView:self numberOfRowsInSection:sections - 1];
            height = [self heightToIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:sections - 1]];
        }
        height += self.tableFooterView.height;
    }
    
    return height;
}

#pragma mark REFRESH CONTROLL

- (void)setupRefreshControllWithActionBlock:(void (^)(void))block
{
    self.refreshControll = [UIRefreshControl new];
    self.refreshControll.tintColor = UBColor.activityColor;
    [self.refreshControll addTarget:self action:@selector(handlerRefreshControll) forControlEvents:UIControlEventValueChanged];
    [self insertSubview:self.refreshControll atIndex:0];
    self.actionBlockOfRefreshControll = block;
}

- (void)handlerRefreshControll
{
    if (self.actionBlockOfRefreshControll)
    {
        self.actionBlockOfRefreshControll();
    }
}

#pragma mark -

- (void)performUpdates:(void (^)(void))updates completion:(void (^)(BOOL))completion
{
    self.disableContentOffsetChange = YES;
    if (@available(iOS 11.0, *))
    {
        [self performBatchUpdates:updates completion:^(BOOL finished) {
            self.disableContentOffsetChange = NO;
            if (completion)
            {
                completion(finished);
            }
        }];
    }
    else
    {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.disableContentOffsetChange = NO;
            if (completion)
            {
                completion(YES);
            }
        }];
        [self beginUpdates];
        if (updates)
        {
            updates();
        }
        [self endUpdates];
        [CATransaction commit];
    }
}

#pragma mark - BACKGROUND FOOTER VIEW

- (void)setupBackgroundFooterViewWithColor:(UIColor *)backgroundColor
{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.footerBackground = [[UIView alloc] initWithFrame:self.bounds];
    self.footerBackground.backgroundColor = [UIColor whiteColor];
    [self.superview insertSubview:self.footerBackground belowSubview:self];
    
    [self.superview setAllConstraintToSubview:self.footerBackground withInsets:UIEdgeInsetsMake(0, 0, 0, self.tableHeaderView.height)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self contentOffsetChanged];
    }
}

- (void)contentOffsetChanged
{
    [self.superview setTopConstraintToSubview:self.footerBackground withValue:self.tableHeaderView.height - self.contentOffset.y];
}

#pragma mark -

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLast = NO;
    NSInteger sectionCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        sectionCount = [self.dataSource numberOfSectionsInTableView:self];
    }
    if (indexPath.section == sectionCount - 1)
    {
        isLast = [self isLastIndexPathInSection:indexPath];
    }
    
    return isLast;
}

- (BOOL)isLastIndexPathInSection:(NSIndexPath *)indexPath
{
    BOOL isLast = NO;
    NSInteger rowCountInSection = [self.dataSource tableView:self numberOfRowsInSection:indexPath.section];
    if (indexPath.row == rowCountInSection - 1)
    {
        isLast = YES;
    }
    
    return isLast;
}

- (CGFloat)heightToIndexPath:(NSIndexPath *)indexPath
{
    CGFloat header_height = 0;
    CGFloat footer_height = 0;
    CGFloat rows_height   = 0;
    
    for (int i = 0; i <= indexPath.section; i++)
    {
        if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        {
            header_height += [self.delegate tableView:self heightForHeaderInSection:i];
        }
        else
        {
            header_height += self.sectionHeaderHeight;
        }
        
        if ([self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        {
            footer_height += [self.delegate tableView:self heightForFooterInSection:i];
        }
        else
        {
            footer_height += self.sectionFooterHeight;
        }
        
        CGFloat rowCount;
        if (indexPath.section == i)
        {
            rowCount = indexPath.row + 1;
        }
        else
        {
            rowCount = [self.dataSource tableView:self numberOfRowsInSection:i];
        }
        
        BOOL cellHeightIsAvailabel = [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        for (int j = 0; j < rowCount; j++)
        {
            if (cellHeightIsAvailabel)
            {
                rows_height += [self.delegate tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            }
            else
            {
                rows_height += self.rowHeight;
            }
        }
    }
    CGFloat total_height = (header_height + footer_height + rows_height);
    total_height += self.tableHeaderView.height;
    total_height -= (self.contentInset.bottom + self.contentInset.top);
    
    return total_height;
}

- (UITableViewCell *)cellFromView:(UIView *)view
{
    UIView *superView = view;
    while (view.superview != Nil)
    {
        superView = superView.superview;
        if ([superView isKindOfClass:[UITableViewCell class]])
        {
            return (UITableViewCell *)superView;
        }
    }
    
    return nil;
}

#pragma mark - SCROLLING 

- (void)placeVisibleView:(UIView *)view withBottomSpace:(CGFloat)space
{
    [self scrollToView:view withBottomSpace:space completionBlock:nil];
}

- (void)scrollToView:(UIView *)view
      withBottomSpace:(CGFloat)bottomSpace
     completionBlock:(void (^)(void))completionBlock
{
    if (view.height + bottomSpace < self.height)
    {
        CGRect frame = [view convertRect:view.bounds toView:nil];
        CGFloat height_1 = CGRectGetMaxY(frame);
        CGFloat height_2 = SCREEN_HEIGHT - bottomSpace;
        CGFloat offsetOfY = (height_1 - height_2);
        
        if (offsetOfY < 0 && ABS(offsetOfY) > self.contentOffset.y)
        {
            offsetOfY = - self.contentOffset.y;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.contentOffset = CGPointMake(0, self.contentOffset.y + offsetOfY);
        } completion:^(BOOL finished) {
            if (completionBlock)
            {
                completionBlock();
            }
        }];
    }
    else if (completionBlock)
    {
        completionBlock();
    }
}

#pragma mark - KEYBOARD HANDLERS

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self setTableBottomEdgeInsets:UBKeyboard.shared.keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self setTableBottomEdgeInsets:0];
}

- (void)setTableBottomEdgeInsets:(CGFloat)bottomInsets
{
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets tableInset = self.contentInset;
        tableInset.bottom = bottomInsets;
        self.contentInset = tableInset;
    }];
}

#pragma mark - SETTERS

- (void)setContentOffset:(CGPoint)contentOffset
{
    if (!self.disableContentOffsetChange)
    {
        [super setContentOffset:contentOffset];
    }
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    if ([tableHeaderView isKindOfClass:UBTableHeaderView.class])
    {
        [tableHeaderView forceHeightUpdate];
    }
    [super setTableHeaderView:tableHeaderView];
}

@end
