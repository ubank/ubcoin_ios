//
//  UBCGoodsCollectionView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodsCollectionView.h"
#import "HUBSpringyCollectionViewFlowLayout.h"
#import "HUBCollectionViewWaitCell.h"
#import "UBCGoodCell.h"

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
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBCGoodCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(UBCGoodCell.class)];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(HUBCollectionViewWaitCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(HUBCollectionViewWaitCell.class)];
}

- (void)setItems:(NSArray<UBCGoodDM *> *)items
{
    _items = items;
    [self reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count + self.canLoadMore;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (SCREEN_WIDTH - ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left * 2 - 10) / 2;
    
    return CGSizeMake(cellWidth, COLLECTION_CELL_HEIGHT);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        [self.actionsDelegate updatePagination];
        
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
    
    [self.actionsDelegate didSelectItem:self.items[indexPath.row]];
}

#pragma mark - Wait Methods

- (BOOL)isWaitCellIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row >= self.items.count;
}

@end
