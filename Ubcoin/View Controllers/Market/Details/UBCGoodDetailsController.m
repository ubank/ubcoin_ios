//
//  UBCGoodDetailsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDetailsController.h"
#import "UBCGoodDetailsController.h"
#import "UBCPhotoCollectionViewCell.h"
#import "UBCGoodsCollectionView.h"
#import "HUBNavigationBarView.h"
#import "UBCInfoLabel.h"
#import "UBCGoodDM.h"
#import "UBCStarsView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Ubcoin-Swift.h"

@interface UBCGoodDetailsController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UBCGoodsCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UBCInfoLabel *photoCount;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;
@property (weak, nonatomic) IBOutlet HUBLabel *price;
@property (weak, nonatomic) IBOutlet HUBLabel *category;
@property (weak, nonatomic) IBOutlet HUBLabel *itemTitle;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBCGoodsCollectionView *relatedItemsView;
@property (weak, nonatomic) IBOutlet UIImageView *sellerAvatar;
@property (weak, nonatomic) IBOutlet HUBLabel *sellerName;
@property (weak, nonatomic) IBOutlet UBCStarsView *sellerRating;
@property (weak, nonatomic) IBOutlet HUBLabel *sellerDesc;

@property (strong, nonatomic) HUBNavigationBarView *navBarView;

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

    [self setupViews];
    [self setupNavBar];
    [self setupContent];
}    

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.background addVerticalGradientWithColors:@[(id)[UIColor clearColor].CGColor,
                                                     (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.navBarView.isTransparent ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)setupNavBar
{
    self.navigationContainer.rightImageTitle = @"general_export";
    self.navigationContainer.titleTextColor = self.navBarView.isTransparent ? UIColor.whiteColor : UBColor.navigationTitleColor;
    self.navigationContainer.buttonsImageColor = self.navBarView.isTransparent ? UIColor.whiteColor : UBColor.navigationTitleColor;;
    self.navigationContainer.clearColorNavigation = YES;
}

- (void)setupViews
{
    self.navBarView = [HUBNavigationBarView loadFromXib];
    self.navBarView.backgroundColor = [UIColor clearColor];
    self.navBarView.isTransparent = YES;
    [self.view addSubview:self.navBarView];
    [self.view setTopConstraintToSubview:self.navBarView withValue:0];
    [self.view setLeadingConstraintToSubview:self.navBarView withValue:0];
    [self.view setTrailingConstraintToSubview:self.navBarView withValue:0];
    
    __weak typeof(self) weakSelf = self;
    self.navBarView.exitActionBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.sellerAvatar.cornerRadius = self.sellerAvatar.height / 2;
    
    self.category.textColor = UBCColor.green;
    self.desc.textColor = UBColor.titleColor;
    
    self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(UBCPhotoCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(UBCPhotoCollectionViewCell.class)];
}

- (void)setupContent
{
    self.title = self.good.title;
    self.itemTitle.text = self.good.title;
    self.category.text = self.good.category.name;
    self.desc.text = self.good.desc;
    self.price.text = [NSString stringWithFormat:@"%@ UBC", self.good.price.priceStringWithoutCoins];
    
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.good.isFavorite ? @"B" : @"A"]];
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"1/%d", (int)self.good.images.count]];
    
    self.relatedItemsView.items = [UBCGoodDM relatedGoods];
    [self setupSellerView:self.good.seller];
}

- (void)setupSellerView:(UBCAuthorDM *)seller
{
    [self.sellerAvatar sd_setImageWithURL:[NSURL URLWithString:seller.avatarURL]
                         placeholderImage:[UIImage imageNamed:@"def_prof"]];
    
    self.sellerName.text = seller.name;
    [self.sellerRating showStars:seller.rating.unsignedIntegerValue];
    
    self.sellerDesc.text = [NSString stringWithFormat:@"%lu items     Reviews(%lu)", (unsigned long)seller.itemsCount, (unsigned long)seller.reviewsCount];
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

- (IBAction)reportPost
{
     
}

- (IBAction)connectToSeller
{
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.navBarView handleScrollOffset:scrollView.contentOffset.y + scrollView.contentInset.top];
    [self setupNavBar];
    [self updateBarButtons];
    [(UBNavigationBar *)((UBNavigationController *)self.navigationController).navigationBar updateCurrentNavigationItem];
    [self setNeedsStatusBarAppearanceUpdate];
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPhoto = self.collectionView.contentOffset.x / self.collectionView.width;
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"%d/%d", (currentPhoto + 1), (int)self.good.images.count]];
}

#pragma mark - UBCGoodsCollectionViewDelegate

- (void)didSelectItem:(UBCGoodDM *)item
{
    UBCGoodDetailsController *controller = [UBCGoodDetailsController.alloc initWithGood:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
