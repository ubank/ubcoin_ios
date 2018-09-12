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
#import "UBCChatController.h"
#import "UBCInfoLabel.h"
#import "UBCGoodDM.h"
#import "UBCKeyChain.h"
#import "UBCStarsView.h"
#import "UBCMapView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Ubcoin-Swift.h"

@interface UBCGoodDetailsController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UBCGoodsCollectionViewDelegate, UBCBuyersViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UBCInfoLabel *photoCount;
@property (weak, nonatomic) IBOutlet UBButton *favoriteButton;
@property (weak, nonatomic) IBOutlet HUBLabel *price;
@property (weak, nonatomic) IBOutlet HUBLabel *priceInCurrency;
@property (weak, nonatomic) IBOutlet HUBLabel *category;
@property (weak, nonatomic) IBOutlet HUBLabel *itemTitle;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet UBCGoodsCollectionView *relatedItemsView;

@property (weak, nonatomic) IBOutlet UIImageView *sellerAvatar;
@property (weak, nonatomic) IBOutlet HUBLabel *sellerName;
@property (weak, nonatomic) IBOutlet UBCStarsView *sellerRating;
@property (weak, nonatomic) IBOutlet HUBLabel *sellerDesc;
@property (weak, nonatomic) IBOutlet UIView *sellerView;
@property (weak, nonatomic) IBOutlet UBCBuyersView *buyersView;

@property (weak, nonatomic) IBOutlet UBCMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *connectToSellerView;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIImageView *warningIcon;
@property (weak, nonatomic) IBOutlet HUBLabel *warningLabel;

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
    
    [UBLocationManager.sharedLocation trackMyLocationOnce:^(BOOL success) {
        
    }];
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
    self.navigationContainer.rightImageTitle = [self navbarIcon];
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
    self.priceInCurrency.textColor = UBColor.descColor;
    
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
    self.price.text = [NSString stringWithFormat:@"%@ UBC", self.good.price.priceString];
    [self setupPriceInCurrency];
    
    self.locationView.hidden = !self.good.location;
    self.mapView.location = self.good.location;
    
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.good.isFavorite ? @"B" : @"A"]];
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"1/%d", (int)self.good.images.count]];
    
    [self setupSellerView:self.good.seller];
    [self setupWarningView];
}

- (void)setupPriceInCurrency
{
    if (self.good.priceInCurrency && self.good.currency)
    {
        self.priceInCurrency.text = [NSString stringWithFormat:@"~%@ %@", self.good.priceInCurrency.priceStringWithoutCoins, self.good.currency];
    }
    else
    {
        self.priceInCurrency.text = @"";
    }
}

- (void)setupWarningView
{
    switch (self.good.status)
    {
        case UBCItemStatusCheck:
        {
            self.warningView.hidden = NO;
            
            UIColor *color = [UIColor colorWithHexString:@"ea9121"];
            self.warningView.backgroundColor = [color colorWithAlphaComponent:0.2];
            self.warningLabel.textColor = color;
            self.warningLabel.text = UBLocalizedString(@"str_status_check", nil);
            self.warningIcon.image = [UIImage imageNamed:@"status_attention"];
        }
            break;
        case UBCItemStatusBlocked:
        {
            self.warningView.hidden = NO;
            
            UIColor *color = RED_COLOR;
            self.warningView.backgroundColor = [color colorWithAlphaComponent:0.2];
            self.warningLabel.textColor = color;
            self.warningLabel.text = UBLocalizedString(@"str_status_blocked", nil);
            self.warningIcon.image = [UIImage imageNamed:@"status_blocked"];
        }
            break;
        default:
            self.warningView.hidden = YES;
            break;
    }
}

- (void)setupSellerView:(UBCSellerDM *)seller
{
    if ([self isMyItem])
    {
        self.connectToSellerView.hidden = YES;
        self.sellerView.hidden = YES;
        self.buyersView.hidden = NO;
        
        [self.buyersView updateWithDeals:self.good.deals];
    }
    else
    {
        self.connectToSellerView.hidden = NO;
        self.sellerView.hidden = NO;
        self.buyersView.hidden = YES;
        
        [self.sellerAvatar sd_setImageWithURL:[NSURL URLWithString:seller.avatarURL]
                             placeholderImage:[UIImage imageNamed:@"def_prof"]];
        
        self.sellerName.text = seller.name;
        [self.sellerRating showStars:seller.rating.unsignedIntegerValue];
        
        self.sellerDesc.text = [NSString stringWithFormat:@"%lu items     Reviews(%lu)", (unsigned long)seller.itemsCount, (unsigned long)seller.reviewsCount];
    }
}

- (BOOL)isMyItem
{
    UBCUserDM *user = [UBCUserDM loadProfile];
    return user.ID && [self.good.seller.ID isEqualToString:user.ID];
}

#pragma mark - Actions

- (void)rightBarButtonClick:(id)sender
{
    if ([self isMyItem])
    {
        [self showItemOptions];
    }
    else
    {
        [self shareItem];
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
    if (UBCKeyChain.authorization)
    {
        UBCChatController *controller = [[UBCChatController alloc] initWithItem:self.good];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [UBAlert showAlertWithTitle:nil andMessage:@"str_you_need_to_be_logged_in"];
    }
}

- (IBAction)showTermsAndConditions
{
    if (self.good.status == UBCItemStatusBlocked)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:USER_AGREEMENT_LINK]
                                           options:@{}
                                 completionHandler:nil];
    }
}

#pragma mark -

- (void)showItemOptions
{
    [UBAlert showActionSheetWithTitle:nil message:nil actions:[self itemOptions] sourceView:nil];
}

- (void)shareItem
{
    if (self.good.shareURL.isNotEmpty)
    {
        [self shareActivityItems:@[self.good.shareURL] withSubject:@"" withSender:nil withCompletionBlock:nil];
    }
}

#pragma mark - Item options

- (NSString *)navbarIcon
{
    if ([self isMyItem])
    {
        switch (self.good.status)
        {
            case UBCItemStatusCheck:
            case UBCItemStatusReserved:
            case UBCItemStatusSold:
                return nil;
                
            default:
                return @"general_options";
        }
    }
    else
    {
        return @"general_export";
    }
}

- (NSArray *)itemOptions
{
    NSMutableArray *actions = [NSMutableArray array];
    switch (self.good.status)
    {
        case UBCItemStatusCheck:
        case UBCItemStatusReserved:
        case UBCItemStatusSold:
            return nil;
            
        case UBCItemStatusBlocked:
            [actions addObject:[self editAction]];
            break;
        case UBCItemStatusDeactivated:
            [actions addObject:[self editAction]];
            [actions addObject:[self activateAction]];
            break;
        case UBCItemStatusActive:
            [actions addObject:[self editAction]];
            [actions addObject:[self deactivateAction]];
            break;
    }
    
    return actions;
}

- (UIAlertAction *)editAction
{
    return [UIAlertAction actionWithTitle:UBLocalizedString(@"ui_button_edit", nil)
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                      
                                  }];
}

- (UIAlertAction *)activateAction
{
    __weak typeof(self)weakSelf = self;
    return [UIAlertAction actionWithTitle:UBLocalizedString(@"str_activate", nil)
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action)
            {
                [weakSelf startActivityIndicator];
                [UBCDataProvider.sharedProvider activateItem:weakSelf.good.ID
                                         withCompletionBlock:^(BOOL success, UBCGoodDM *item)
                 {
                     [weakSelf stopActivityIndicator];
                     if (success)
                     {
                         weakSelf.good = item;
                         [weakSelf setupContent];
                     }
                 }];
            }];
}

- (UIAlertAction *)deactivateAction
{
    __weak typeof(self)weakSelf = self;
    return [UIAlertAction actionWithTitle:UBLocalizedString(@"str_deactivate", nil)
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action)
            {
                [weakSelf startActivityIndicator];
                [UBCDataProvider.sharedProvider deactivateItem:weakSelf.good.ID
                                           withCompletionBlock:^(BOOL success, UBCGoodDM *item)
                 {
                     [weakSelf stopActivityIndicator];
                     if (success)
                     {
                         weakSelf.good = item;
                         [weakSelf setupContent];
                     }
                 }];
            }];
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
    [cell loadImageToFillWithURL:imageURL withDefaultImage:[UIImage imageNamed:@"item_default_image"] forImageView:cell.icon];
    
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

#pragma mark - UBCBuyersViewDelegate

- (void)didSelectWithDeal:(UBCDealDM *)deal
{
    UBCChatController *controller = [[UBCChatController alloc] initWithDeal:deal];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
