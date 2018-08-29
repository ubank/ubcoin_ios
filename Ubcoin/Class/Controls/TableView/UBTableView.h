//
//  UBTableView.h
//  uBank
//
//  Created by Ravil on 6/10/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

@interface UBTableView : UITableView

@property (assign, nonatomic, readonly) CGFloat contentHeight;
@property (strong, nonatomic, readonly) UIRefreshControl *refreshControll;
@property (strong, nonatomic, readonly) HUBEmptyView *emptyView;

- (void)performUpdates:(void (^)(void))updates completion:(void (^)(BOOL))completion;

- (void)setupRefreshControllWithActionBlock:(void (^)(void))block;

- (void)setupBackgroundFooterViewWithColor:(UIColor *)backgroundColor;

- (void)placeVisibleView:(UIView *)view withBottomSpace:(CGFloat)space;

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isLastIndexPathInSection:(NSIndexPath *)indexPath;

- (UITableViewCell *)cellFromView:(UIView *)view;

@end
