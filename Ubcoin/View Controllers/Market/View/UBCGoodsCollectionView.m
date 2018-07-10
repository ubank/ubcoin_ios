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

#import "Ubcoin-Swift.h"

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
    self.backgroundColor = UBColor.backgroundColor;
    self.delegate = self;
    self.dataSource = self;
    self.alwaysBounceVertical = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.refreshControl = UIRefreshControl.new;
    self.refreshControl.tintColor = UBCColor.green;
    [self.refreshControl addTarget:self action:@selector(refreshControlUpdate) forControlEvents:UIControlEventValueChanged];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBCGoodCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(UBCGoodCell.class)];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(HUBCollectionViewWaitCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(HUBCollectionViewWaitCell.class)];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBCDiscountsCollectionView.class) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(UBCDiscountsCollectionView.class)];
}

- (void)setDiscounts:(NSArray<UBCDiscountDM *> *)discounts
{
    _discounts = discounts;
    [self reloadData];
}

- (void)setItems:(NSArray<UBCGoodDM *> *)items
{
    _items = items;
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
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.discounts.count > 0)
    {
        return CGSizeMake(collectionView.width, DISCOUNTS_HEIGHT);
    }
    
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count + self.canLoadMore;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (SCREEN_WIDTH - ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left * 2 - UBCConstant.inset) / 2;
    
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
