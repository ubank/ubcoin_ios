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
#import "UBCMapView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Ubcoin-Swift.h"
@import ImageSlideshow;

@interface UBCGoodDetailsController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UBCGoodsCollectionViewDelegate, UBCBuyersViewDelegate, UBCSellerViewDelegate>

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
@property (weak, nonatomic) IBOutlet HUBLabel *rateUBC;
@property (weak, nonatomic) IBOutlet UBCGoodsCollectionView *relatedItemsView;

@property (weak, nonatomic) IBOutlet UIView *sellerSectionView;
@property (weak, nonatomic) IBOutlet UBCSellerView *sellerView;
@property (weak, nonatomic) IBOutlet UBCBuyersView *buyersView;

@property (weak, nonatomic) IBOutlet HUBLabel *address;
@property (weak, nonatomic) IBOutlet UBCMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *connectToSellerView;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIImageView *warningIcon;
@property (weak, nonatomic) IBOutlet HUBLabel *warningLabel;

@property (strong, nonatomic) HUBNavigationBarView *navBarView;

@property (strong, nonatomic) UBCGoodDM *good;
@property (strong, nonatomic) NSString *goodID;

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

- (instancetype)initWithGoodID:(NSString *)goodID
{
    self = [super init];
    if (self)
    {
        self.goodID = goodID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViews];
    [self setupNavBar];
    
    if (self.good)
    {
        [self setupContent];
    }
    else if (self.goodID)
    {
        [self startActivityIndicatorImmediately];
        
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider goodWithID:self.goodID
                               withCompletionBlock:^(BOOL success, UBCGoodDM *item)
         {
             [weakSelf stopActivityIndicator];
             if (success && item)
             {
                 weakSelf.good = item;
                 [weakSelf setupContent];
             }
             else
             {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
    
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
    self.navigationContainer.buttonsImageColor = self.navBarView.isTransparent ? UIColor.whiteColor : UBColor.navigationTitleColor;
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
    
    self.category.textColor = UBCColor.green;
    self.desc.textColor = UBColor.titleColor;
    self.rateUBC.textColor = UBColor.descColor;
    self.address.textColor = UBColor.titleColor;
    
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
    self.rateUBC.text = [NSString stringWithFormat:@"1 UBC = %@ USD", self.good.rateUBC.priceString];
    [self setupPriceInCurrency];
    
    self.locationView.hidden = !self.good.location;
    self.mapView.location = self.good.location;
    self.address.text = self.good.locationText;
    
    self.favoriteButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"icFav%@", self.good.isFavorite ? @"B" : @"A"]];
    self.favoriteButton.hidden = self.good.isMyItem;
    [self.photoCount setupWithImage:[UIImage imageNamed:@"market_photo"]
                            andText:[NSString stringWithFormat:@"1/%d", (int)self.good.images.count]];
    [self.collectionView reloadData];
    
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

- (void)setupRateUBC
{
    if (self.good.rateUBC && self.good.currency)
    {
        NSNumberFormatter *format = NSNumberFormatter.new;
        
        format.groupingSize = 3;
        format.groupingSeparator = @" ";
        format.locale = UBLocal.shared.locale;
        format.minimumFractionDigits = 0;
        format.maximumFractionDigits = 4;
        format.numberStyle = NSNumberFormatterDecimalStyle;
        
        self.rateUBC.text = [NSString stringWithFormat:@"1 UBC = %@ USD", [format stringFromNumber:self.good.rateUBC]];
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
        case UBCItemStatusChecking:
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
        case UBCItemStatusDeactivated:
        {
            self.warningView.hidden = NO;
            
            self.warningView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
            self.warningLabel.textColor = [UIColor colorWithHexString:@"5b676d"];
            self.warningLabel.text = UBLocalizedString(@"str_status_deactivated", nil);
            self.warningIcon.image = [UIImage imageNamed:@"status_deactivated"];
        }
            break;
        default:
            self.warningView.hidden = YES;
            break;
    }
}

- (void)setupSellerView:(UBCSellerDM *)seller
{
    if ([self.good isMyItem])
    {
        self.connectToSellerView.hidden = YES;
        self.sellerSectionView.hidden = YES;
        self.buyersView.hidden = NO;
        
        [self.buyersView updateWithDeals:self.good.deals];
    }
    else
    {
        self.connectToSellerView.hidden = NO;
        self.sellerSectionView.hidden = NO;
        self.buyersView.hidden = YES;
        
        [self.sellerView setupWithSeller:self.good.seller];
    }
}

#pragma mark - Actions

- (void)rightBarButtonClick:(id)sender
{
    if ([self.good isMyItem])
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
        NSString *textToShare = [NSString stringWithFormat:@"%@ — buy fast and safe for cryptocurrency on Ubcoin Market.\n%@", self.good.title, self.good.shareURL];
        [self shareActivityItems:@[textToShare] withSubject:@"" withSender:nil withCompletionBlock:nil];
    }
}

#pragma mark - Item options

- (NSString *)navbarIcon
{
    if ([self.good isMyItem])
    {
        switch (self.good.status)
        {
            case UBCItemStatusChecking:
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
        case UBCItemStatusChecking:
        case UBCItemStatusReserved:
        case UBCItemStatusSold:
            return nil;
            
        case UBCItemStatusBlocked:
        case UBCItemStatusCheck:
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
    __weak typeof(self)weakSelf = self;
    return [UIAlertAction actionWithTitle:UBLocalizedString(@"ui_button_edit", nil)
                                    style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action)
            {
                UBCSellController *controller = [UBCSellController.alloc initWithItem:weakSelf.good];
                [weakSelf.navigationController pushViewController:controller animated:YES];
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
                         [UBAlert showAlertWithTitle:nil andMessage:@"str_the_listing_is_activated"];
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
                         [UBAlert showAlertWithTitle:nil andMessage:@"str_the_listing_is_deactivated"];
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
    [cell layoutIfNeeded];
    
    NSString *imageURL = self.good.images[indexPath.row];
    [cell loadImageToFillWithURL:imageURL withDefaultImage:[UIImage imageNamed:@"item_default_image"] forImageView:cell.icon];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FullScreenSlideshowViewController *controller = FullScreenSlideshowViewController.new;
    NSArray *inputs = [self.good.images map:^id(id item) {
        return [UBCImageSource.alloc initWithUrlString:item placeholder:nil];
    }];
    
    controller.inputs = inputs;
    controller.initialPage = indexPath.row;
    controller.closeButton.hidden = YES;
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationController pushViewController:controller animated:YES];
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

#pragma mark - UBCSellerViewDelegate

- (void)showWithSeller:(UBCSellerDM *)seller
{
    UBCSellerController *controller = [[UBCSellerController alloc] initWithSeller:seller];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
