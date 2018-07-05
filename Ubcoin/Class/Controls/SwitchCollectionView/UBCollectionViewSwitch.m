//
//  UBCollectionViewSwitch.m
//  uBank
//
//  Created by RAVIL on 4/14/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

#import "UBCollectionViewSwitch.h"

#define HEIGHT_OF_INDICATOR 3

@interface UBCollectionViewSwitch () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic, readwrite) UICollectionView *collectionView;
@property (assign, nonatomic, readwrite) NSUInteger pageIndex;
@property (assign, nonatomic, readwrite) NSUInteger numberOfPages;

@property (nonatomic) UIImageView *indicatorView;
@property (nonatomic) UIScrollView *buttonsScrollView;

@property (nonatomic) CGPoint previousLocation;
@property (nonatomic) CGFloat heightOfPanel;
@property (nonatomic) CGFloat heightOfIndicator;
@property (nonatomic) CGFloat buttonWidth;

@property (nonatomic) NSArray *arrayOfPages;

@property (nonatomic) NSUInteger numberOfTitles;
@property (nonatomic) NSUInteger numberOfViews;

@property (copy, nonatomic) void (^methodBlockOfEndScrolling)(NSUInteger centerPage);

@end

@implementation UBCollectionViewSwitch

static NSString * const identifier = @"collectionCellIdentifier";

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withArrayOfPagesContent:(NSArray *)array
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        [self updateArrayOfPagesContent:array];
    }
    
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.showButtonsPanel = YES;
    [self setupButtonsScrollView];
    [self setupCollectionView];
    [self setupIndicatorView];
}

- (void)updateArrayOfPagesContent:(NSArray *)array
{
    self.pageIndex = 0;
    self.arrayOfPages = array;
    self.numberOfPages = [self.arrayOfPages count];
    
    [self parseArray];
    [self updateLayout];
}

- (void)parseArray
{
    self.numberOfTitles = 0;
    self.numberOfViews = 0;
    for (UBCollectionViewSwitchContent *content in self.arrayOfPages)
    {
        if (content.contentView)
        {
            self.numberOfViews ++;
        }
        if (content.attributedStringOfTitle)
        {
            self.numberOfTitles ++;
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((UBCollectionViewSwitchContent *)evaluatedObject).isSelected;
    }];
    
    UBCollectionViewSwitchContent *content = [[self.arrayOfPages filteredArrayUsingPredicate:predicate] firstObject];
    if (content)
    {
        self.pageIndex = [self.arrayOfPages indexOfObject:content];
    }
}

- (void)scrollToNeededPage
{
    [self scrollToPage:self.pageIndex withAnimation:NO];
    [self setCenterPageIndex:self.pageIndex];
}

#pragma mark SETUP SUBVIEWS

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = UICollectionViewFlowLayout.new;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

- (void)setupIndicatorView
{
    self.indicatorView = UIImageView.new;
    self.indicatorView.backgroundColor = [UIColor clearColor];
    self.indicatorView.contentMode = UIViewContentModeCenter;
    [self.buttonsScrollView addSubview:self.indicatorView];
}

- (void)setupButtonsScrollView
{
    self.buttonsScrollView = UIScrollView.new;
    self.buttonsScrollView.backgroundColor = LIGHT_GRAY_COLOR;
    self.buttonsScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.buttonsScrollView];
}

- (UBButton *)createButtonWithFrame:(CGRect)frame attributtedTitle:(NSAttributedString *)attributedTitle
{
    UBButton *button = [[UBButton alloc] initWithFrame:frame];
    
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    
    return button;
}

#pragma mark - LAYOUT

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayout];
}

- (void)updateLayout
{
    [self updateFrames];
    [self updateContentsView];
    [self updateButtons];
    [self reloadData];
}

- (void)reloadData
{
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self scrollToNeededPage];
}

#pragma mark - UPDATE

- (void)updateFrames
{
    NSInteger count = [self.arrayOfPages count];
    if (count == 1 || !self.showButtonsPanel)
    {
        self.heightOfPanel = 0;
        self.heightOfIndicator = 0;
    }
    else if (count > 1)
    {
        self.heightOfPanel = HEIGHT_OF_PANEL;
        self.heightOfIndicator = HEIGHT_OF_INDICATOR;
    }
    
    CGRect frameOfCollectionView = CGRectMake(0, self.heightOfPanel, self.bounds.size.width, self.bounds.size.height - self.heightOfPanel);
    
    self.collectionView.frame = frameOfCollectionView;
    self.buttonsScrollView.frame = CGRectMake(0, 0, self.width, self.heightOfPanel);
}

- (void)updateButtons
{
    [self removeButtons];
    
    if (self.showButtonsPanel)
    {
        self.buttonWidth          = 0;
        CGFloat buttonX           = 0;
        CGFloat buttonHeight      = self.heightOfPanel - 0.5;
        CGFloat freeSpaceInButton = (self.width * 0.05) * 2;

        for (UBCollectionViewSwitchContent *content in self.arrayOfPages)
        {
            CGSize size = [content.attributedStringOfTitle sizeWithAttributedString];
            self.buttonWidth = MAX(self.buttonWidth, (size.width + freeSpaceInButton));
        }
        
        CGFloat difference = self.width - (self.buttonWidth * self.arrayOfPages.count);
        if (difference > 0 && self.arrayOfPages.count > 0)
        {
            self.buttonWidth += difference / self.arrayOfPages.count;
        }
        
        for (int i = 0; i < [self.arrayOfPages count]; i++)
        {
            UBCollectionViewSwitchContent *content = self.arrayOfPages[i];
            CGRect frameOfButton = CGRectMake(buttonX, 0, self.buttonWidth, buttonHeight);
            UBButton *button = [self createButtonWithFrame:frameOfButton attributtedTitle:content.attributedStringOfTitle];
            button.tag = i + 1;
            [self.buttonsScrollView insertSubview:button belowSubview:self.indicatorView];
            buttonX += self.buttonWidth;
        }
        
        self.buttonsScrollView.contentSize = CGSizeMake((int)(buttonX), self.buttonsScrollView.height);
        
        CGFloat indicatorWitdh = self.buttonWidth;
        UIImage *image = [UIImage imageWithColor:BROWN_COLOR size:CGSizeMake(indicatorWitdh, self.heightOfIndicator)];
        self.indicatorView.image = image;
        self.indicatorView.frame  = CGRectMake(indicatorWitdh * self.pageIndex, self.buttonsScrollView.height - self.heightOfIndicator, indicatorWitdh, self.heightOfIndicator);
    }
}

- (void)removeButtons
{
    for (UBButton *button in [self.buttonsScrollView subviews])
    {
        if ([button isKindOfClass:[UBButton class]] && button.tag > 0)
        {
            [button removeFromSuperview];
        }
    }
}

- (void)updateContentsView
{
    for (int i = 0; i < [self.arrayOfPages count]; i++)
    {
        UBCollectionViewSwitchContent *content = self.arrayOfPages[i];
        UIView *contentView = content.contentView;
        if (contentView)
        {
            contentView.frame = CGRectMake(0, 0, self.collectionView.width, self.collectionView.height);
            contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            contentView.tag = i + 1;
        }
    }
}

#pragma mark - HANDLER

- (void)buttonPressed:(UBButton *)button
{
    NSUInteger page = button.tag - 1;
    if (self.numberOfViews > 1)
    {
        [self scrollToPage:page withAnimation:YES];
    }
    else
    {
        [self scrollIndicatorToPageWithoutScrollingContent:page withAnimation:YES];
    }
}

- (void)callBlockOfEndScrolling
{
    if (self.methodBlockOfEndScrolling)
    {
        self.methodBlockOfEndScrolling(self.pageIndex);
        self.methodBlockOfEndScrolling = nil;
    }
    else if (self.blockOfEndScrollingToPage)
    {
        self.blockOfEndScrollingToPage(self.pageIndex);
    }
}

#pragma mark - SCROLL INDICATOR

- (void)scrollIndicatorWithScrollViewContentOffset:(CGPoint)offset
{
    self.indicatorView.originX = (self.buttonsScrollView.contentSize.width * offset.x) / self.buttonsScrollView.width / self.numberOfTitles;
}

- (void)scrollIndicatorToPageWithoutScrollingContent:(NSUInteger)page withAnimation:(BOOL)animation
{
    CGFloat duration = animation ? 0.25 : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.indicatorView.originX = self.indicatorView.width * page;
    } completion:^(BOOL finished) {
        [self setCenterPageIndex:page];
    }];
}

- (void)scrollToPage:(NSUInteger)pageIndex withAnimation:(BOOL)animation
{
    if (self.numberOfViews == self.numberOfTitles && pageIndex < self.numberOfViews)
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:animation];
        self.pageIndex = pageIndex;
    }
    else if (pageIndex < self.numberOfTitles)
    {
        [self scrollIndicatorToPageWithoutScrollingContent:pageIndex withAnimation:animation];
    }
}

- (void)scrollToPage:(NSUInteger)pageIndex
        withAnimation:(BOOL)animation
           completion:(void (^)(NSUInteger centerPage))completionBlock
{
    self.methodBlockOfEndScrolling = completionBlock;
    [self scrollToPage:pageIndex withAnimation:animation];
}

- (void)scrollToNextPage
{
    [self scrollToPage:self.pageIndex + 1 withAnimation:YES];
}

#pragma mark UISCROLL_VIEW_DELEGATE

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.numberOfViews > 1)
    {
        [self scrollIndicatorWithScrollViewContentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setCenterPageIndex:[self getCenterPageIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setCenterPageIndex:[self getCenterPageIndex]];
}

#pragma mark -

- (void)setCenterPageIndex:(NSUInteger)page
{
    self.pageIndex = page;
    if (self.arrayOfPages.count > 0)
    {
        CGRect visibleRect = CGRectMake(self.buttonWidth * self.pageIndex, 0, self.buttonWidth, self.buttonsScrollView.height);
        [self.buttonsScrollView scrollRectToVisible:visibleRect animated:YES];

        [self.arrayOfPages setValue:@0 forKey:@"isSelected"];
        UBCollectionViewSwitchContent *content = self.arrayOfPages[self.pageIndex];
        content.isSelected = YES;
    }
    [self callBlockOfEndScrolling];
    [self selectCurrentTab];
}

- (NSUInteger)getCenterPageIndex
{
    NSUInteger pageIndex = 0;
    if (self.numberOfViews > 1)
    {
        CGPoint point = CGPointMake(ABS(self.collectionView.contentOffset.x) + self.collectionView.width / 2, CGRectGetMidY(self.collectionView.frame));
        NSIndexPath *centerCellIndexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (centerCellIndexPath)
        {
            pageIndex = centerCellIndexPath.row;
        }
    }
    
    return pageIndex;
}

- (void)selectCurrentTab
{
    for (UBButton *button in [self.buttonsScrollView subviews])
    {
        if ([button isKindOfClass:[UBButton class]])
        {
            NSUInteger tag = button.tag;
            UBCollectionViewSwitchContent *content = self.arrayOfPages[tag - 1];
            NSAttributedString *att = (button.tag == (self.pageIndex + 1)) ? content.attributedStringOfTitle : content.highlightedAttributedString;
            [button setAttributedTitle:att forState:UIControlStateNormal];
        }
    }
}

#pragma mark - COLLECTION DATA_SOURCE

- (CGSize)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfViews;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    collectionViewCell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UBCollectionViewSwitchContent *content = self.arrayOfPages[indexPath.row];
    UIView *contentView = content.contentView;
    [self removePreviosSubviewFromCell:collectionViewCell];
    if (contentView)
    {
        [collectionViewCell addSubview:content.contentView];
    }

    return collectionViewCell;
}

- (void)removePreviosSubviewFromCell:(UICollectionViewCell *)cell
{
    for (UIView *view in cell.subviews)
    {
        if (view.tag > 0)
        {
            [view removeFromSuperview];
        }
    }
}

@end
