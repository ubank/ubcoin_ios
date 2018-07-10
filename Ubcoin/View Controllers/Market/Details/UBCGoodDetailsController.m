//
//  UBCGoodDetailsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDetailsController.h"
#import "UBCPhotoCollectionViewCell.h"
#import "UBCInfoLabel.h"
#import "UBCGoodDM.h"

#import "Ubcoin-Swift.h"

@interface UBCGoodDetailsController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UBCInfoLabel *photoCount;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;
@property (weak, nonatomic) IBOutlet HUBLabel *price;
@property (weak, nonatomic) IBOutlet HUBLabel *category;
@property (weak, nonatomic) IBOutlet HUBLabel *itemTitle;

@property (strong, nonatomic) UBCGoodDM *good;

@end

@implementation UBCGoodDetailsController

- (instancetype)initWithGood:(UBCGoodDM *)good
{
    self = [super init];
    if (self)
    {
        self.good = good;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavBar];
    [self setupContent];
    
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(UBCPhotoCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(UBCPhotoCollectionViewCell.class)];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupNavBar
{
    self.navigationContainer.rightImageTitle = @"general_export";
    self.navigationContainer.titleTextColor = UIColor.whiteColor;
    self.navigationContainer.buttonsImageColor = UIColor.whiteColor;
    self.navigationContainer.clearColorNavigation = YES;
}

- (void)setupViews
{
    self.category.textColor = UBCColor.green;
}

- (void)setupContent
{
    self.title = self.good.title;
    self.itemTitle.text = self.good.title;
    self.category.text = self.category.name;
    self.price.text = [NSString stringWithFormat:@"%@ UBC", self.good.price.priceStringWithoutCoins];
    
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.good.isFavorite ? @"B" : @"A"]];
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"1/%d", (int)self.good.images.count]];
}

#pragma mark - Actions

- (void)rightBarButtonClick:(id)sender
{
    NSString *imageURL = self.good.images.firstObject;
    if (imageURL)
    {
        [self shareActivityItems:@[imageURL] withSubject:@"" withSender:sender withCompletionBlock:nil];
    }
}

- (IBAction)toggleFavorite
{
    [self.good toggleFavorite];
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.good.isFavorite ? @"B" : @"A"]];
    [self.favoriteButton animateScaleWithAlphaWithTransform:0.4 withCompletion:nil];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.good.images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UBCPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UBCPhotoCollectionViewCell.class) forIndexPath:indexPath];
    
    NSString *imageURL = self.good.images[indexPath.row];
    [cell loadImageToFillWithURL:imageURL withDefaultImage:nil forImageView:cell.icon];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPhoto = self.collectionView.contentOffset.x / self.collectionView.width;
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"%d/%d", (currentPhoto + 1), (int)self.good.images.count]];
}

@end
