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

@property (assign, nonatomic) CGFloat cellWidth;

@end

@implementation UBCDiscountsCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.pageIndicatorTintColor = UBColor.descColor;
    self.pageControl.currentPageIndicatorTintColor = UBCColor.green;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"UBCDiscountCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"UBCDiscountCollectionViewCell"];
}

- (void)setDiscounts:(NSArray *)discounts
{
    _discounts = discounts;
    self.pageControl.numberOfPages = discounts.count;
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
    self.cellWidth = MIN(295, cellWidth);
    
    return CGSizeMake(self.cellWidth, DISCOUNT_CELL_HEIGHT);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.collectionView.contentOffset.x / self.cellWidth;
}

@end
