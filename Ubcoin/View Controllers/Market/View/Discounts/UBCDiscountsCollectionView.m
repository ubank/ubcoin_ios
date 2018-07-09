//
//  UBCDiscountsCollectionView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDiscountsCollectionView.h"
#import "UBCDiscountCollectionViewCell.h"

#import "Ubcoin-Swift.h"

@interface UBCDiscountsCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation UBCDiscountsCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.tintColor = RED_COLOR;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"UBCDiscountCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"UBCDiscountCollectionViewCell"];
}

- (void)setDiscounts:(NSArray *)discounts
{
    _discounts = discounts;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.discounts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = SCREEN_WIDTH - ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left * 2 - UBCConstant.inset;
    
    return CGSizeMake(MIN(295, cellWidth), DISCOUNT_CELL_HEIGHT);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = indexPath.row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UBCDiscountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UBCDiscountCollectionViewCell" forIndexPath:indexPath];
    
    [cell setContent:self.discounts[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate showDiscountInfo:self.discounts[indexPath.row]];
}

@end
