//
//  UBCGoodsCollectionView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodsCollectionView.h"
#import "HUBSpringyCollectionViewFlowLayout.h"
#import "UBCDiscountsCollectionView.h"
#import "HUBCollectionViewWaitCell.h"
#import "UBCGoodCell.h"

@interface UBCGoodsCollectionView()

@property (strong, nonatomic, readwrite) HUBEmptyView *emptyView;

@end

@implementation UBCGoodsCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionViewLayout = HUBSpringyCollectionViewFlowLayout.new;
    
    [self setup];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:HUBSpringyCollectionViewFlowLayout.new];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark -

- (void)setup
{
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = UIColor.clearColor;
    self.delegate = self;
    self.dataSource = self;
    self.alwaysBounceVertical = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.refreshControl = UIRefreshControl.new;
    [self.refreshControl addTarget:self action:@selector(refreshControlUpdate) forControlEvents:UIControlEventValueChanged];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBCGoodCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(UBCGoodCell.class)];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(HUBCollectionViewWaitCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(HUBCollectionViewWaitCell.class)];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBCDiscountsCollectionView.class) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UBCDiscountsCollectionView.class)];
    
    [self setupEmptyView];
}

- (void)setupEmptyView
{
    self.emptyView = [HUBEmptyView loadFromXib];
    self.emptyView.hidden = YES;
    [self addSubview:self.emptyView];
    [self setTopConstraintToSubview:self.emptyView withValue:0];
    [self setLeadingConstraintToSubview:self.emptyView withValue:0];
    [self setTrailingConstraintToSubview:self.emptyView withValue:0];
    [self setWidthEqualToSubview:self.emptyView];
}

- (void)setDiscounts:(NSArray<UBCDiscountDM *> *)discounts
{
    _discounts = discounts;
    [self reloadData];
}

- (void)setItems:(NSArray<UBCGoodDM *> *)items
{
    _items = items;
    self.emptyView.hidden = items.count > 0;
    [self reloadData];
}

#pragma mark - Actions

- (void)refreshControlUpdate
{
    if ([self.actionsDelegate respondsToSelector:@selector(refreshControlUpdate)])
    {
        [self.actionsDelegate refreshControlUpdate];
    }
}

#pragma mark - UICollectionView

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.discounts.count > 0)
    {
        UBCDiscountsCollectionView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(UBCDiscountsCollectionView.class) forIndexPath:indexPath];
        view.delegate = self;
        view.discounts = self.discounts;
        return view;
    }
    else if ([self.actionsDelegate respondsToSelector:@selector(viewForSupplementaryElementOfKind:atIndexPath:)])
    {
        return [self.actionsDelegate viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.discounts.count > 0)
    {
        return CGSizeMake(collectionView.width, DISCOUNTS_HEIGHT);
    }
    else if ([self.actionsDelegate respondsToSelector:@selector(referenceSizeForHeaderInSection:)])
    {
        return [self.actionsDelegate referenceSizeForHeaderInSection:section];
    }
    
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count + self.canLoadMore;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (SCREEN_WIDTH - ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left * 2 - 5) / 2;
    
    return CGSizeMake(cellWidth, COLLECTION_CELL_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        if ([self.actionsDelegate respondsToSelector:@selector(updatePagination)])
        {
            [self.actionsDelegate updatePagination];
        }
        
        HUBCollectionViewWaitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HUBCollectionViewWaitCell.class) forIndexPath:indexPath];

        [cell.activity startAnimating];

        return cell;
    }
    
    UBCGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UBCGoodCell.class) forIndexPath:indexPath];
    
    cell.content = self.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        return;
    }
    
    if ([self.actionsDelegate respondsToSelector:@selector(didSelectItem:)])
    {
        [self.actionsDelegate didSelectItem:self.items[indexPath.row]];
    }
}

#pragma mark - Wait Methods

- (BOOL)isWaitCellIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row >= self.items.count;
}

#pragma mark - UBCDiscountsCollectionViewDelegate

- (void)showDiscountInfo:(UBCDiscountDM *)discount
{
    if ([self.actionsDelegate respondsToSelector:@selector(didSelectDiscount:)])
    {    
        [self.actionsDelegate didSelectDiscount:discount];
    }
}

@end
