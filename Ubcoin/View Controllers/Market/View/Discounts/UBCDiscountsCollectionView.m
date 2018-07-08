//
//  UBCDiscountsCollectionView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDiscountsCollectionView.h"
#import "UBCDiscountCollectionViewCell.h"

@interface UBCDiscountsCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation UBCDiscountsCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
    NSUInteger rowsCount = [self collectionView:collectionView numberOfItemsInSection:indexPath.section];
    CGFloat cellWidth = SCREEN_WIDTH - ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left * 2;
    
    if (rowsCount == 1)
    {
        return CGSizeMake(cellWidth, DISCOUNT_CELL_HEIGHT);
    }
    else if (rowsCount == 2)
    {
        return CGSizeMake(cellWidth / 2, DISCOUNT_CELL_HEIGHT);
    }
    else
    {
        CGFloat smallCellWidth = (cellWidth - 10) / 2;
        
        return CGSizeMake(roundf(smallCellWidth), DISCOUNT_CELL_HEIGHT);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UBCDiscountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UBCDiscountCollectionViewCell" forIndexPath:indexPath];
    
    [cell setContent:self.discounts[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.delegate showDiscountInfo:self.discounts[indexPath.row]];
}

@end
