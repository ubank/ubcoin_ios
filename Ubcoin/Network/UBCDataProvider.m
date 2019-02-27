//
//  UBCDataProvider.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDataProvider.h"
#import "UBConnectionProvider.h"
#import "UBCRequestProvider.h"
#import "UBCURLProvider.h"

#import "UBCGoodDM.h"
#import "UBCDealDM.h"
#import "UBCUserDM.h"
#import "UBCBalanceDM.h"
#import "UBCPaymentDM.h"
#import "UBCDiscountDM.h"
#import "UBCCategoryDM.h"
#import "UBCTransactionDM.h"
#import "UBCKeyChain.h"
#import "UBCFavouriteCell.h"
#import "UBCDealCell.h"

#import <AFNetworking/UIKit+AFNetworking.h>
#import <OneSignal/OneSignal.h>

#import "Ubcoin-Swift.h"

@interface UBCDataProvider ()

@property (strong, nonatomic) UBConnectionProvider *connection;

@end


@implementation UBCDataProvider

+ (instancetype)sharedProvider
{
    static UBCDataProvider *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = self.new;
        sharedInstance.connection = UBConnectionProvider.new;
    });
    
    return sharedInstance;
}

- (NSURLSessionDataTask *)goodsListWithPageNumber:(NSUInteger)page andFilters:(NSString *)filters withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider goodsListWithPageNumber:page andFilters:filters];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    return [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 return [[UBCGoodDM alloc] initWithDictionary:item];
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page + 1);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

- (NSURLSessionDataTask *)goodsListWithPageNumber:(NSUInteger)page forSeller:(NSString *)sellerID withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider goodsListWithPageNumber:page forSeller:sellerID];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    return [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
            {
                if (success)
                {
                    NSArray *items = [responseObject[@"data"] removeNulls];
                    items = [items map:^id(id item) {
                        return [[UBCGoodDM alloc] initWithDictionary:item];
                    }];
                    
                    if (completionBlock)
                    {
                        NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                        completionBlock(YES, items, totalPages.integerValue > page + 1);
                    }
                }
                else if (completionBlock)
                {
                    completionBlock(NO, nil, YES);
                }
            }];
}

- (NSURLSessionDataTask *)goodsCountWithFilters:(NSString *)filters withCompletionBlock:(void (^)(BOOL, NSString *))completionBlock
{
    NSURL *url = [UBCURLProvider goodsCountWithFilters:filters];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    return [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
            {
                if (completionBlock)
                {
                    responseObject = [responseObject removeNulls];
                    completionBlock(success, responseObject[@"count"]);
                }
            }];
}

- (void)goodWithID:(NSString *)itemID withCompletionBlock:(void (^)(BOOL, UBCGoodDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider goodWithID:itemID]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             UBCGoodDM *item = [UBCGoodDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, item);
         }
         else if (completionBlock)
         {
             completionBlock(success, nil);
         }
     }];
}

- (void)sellerWithID:(NSString *)sellerID withCompletionBlock:(void (^)(BOOL, UBCSellerDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider sellerWithID:sellerID]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             UBCSellerDM *seller = [UBCSellerDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, seller);
         }
         else if (completionBlock)
         {
             completionBlock(success, nil);
         }
     }];
}

- (void)activateItem:(NSString *)itemID withCompletionBlock:(void (^)(BOOL, UBCGoodDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider activateItem]
                                                                andParams:@{@"itemId": itemID}];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             UBCGoodDM *item = [UBCGoodDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, item);
         }
         else if (completionBlock)
         {
             completionBlock(success, nil);
         }
     }];
}

- (void)deactivateItem:(NSString *)itemID withCompletionBlock:(void (^)(BOOL, UBCGoodDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider deactivateItem]
                                                                andParams:@{@"itemId": itemID}];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             UBCGoodDM *item = [UBCGoodDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, item);
         }
         else if (completionBlock)
         {
             completionBlock(success, nil);
         }
     }];
}

#pragma mark -

- (void)discountsWithCompletionBlock:(void (^)(BOOL, NSArray *))completionBlock
{
    if (completionBlock)
    {
//        UBCDiscountDM *discount1 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"Apple stuff",
//                                                                               @"description": @"Celebrate 10 years of iPhone",
//                                                                               @"image": @"ad_banner_1"}];
//        UBCDiscountDM *discount2 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"New bicycle",
//                                                                               @"description": @"Just take a ride",
//                                                                               @"image": @"ad_banner_2"}];
//        UBCDiscountDM *discount3 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"Interior",
//                                                                               @"description": @"Bright and modern details",
//                                                                               @"image": @"ad_banner_3"}];
//        completionBlock(YES, @[discount1, discount2, discount3]);
        completionBlock(YES, @[]);
    }
}

- (void)categoriesWithCompletionBlock:(void (^)(BOOL, NSArray *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider categories]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [[responseObject removeNulls] map:^id(id item) {
                 return [[UBCCategoryDM alloc] initWithDictionary:item];
             }];
             
             if (completionBlock)
             {
                 completionBlock(YES, items);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil);
         }
     }];
}

#pragma mark - LOGIN

- (void)loginWithEmail:(NSString *)email password:(NSString *)password withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider login]
                                                                andParams:@{@"email" : [email stringByTrimmingEmptySymbolsAtTheEnds],
                                                                            @"password" : password}];
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             responseObject = [responseObject removeNulls];
             UBCKeyChain.authorization = responseObject[@"accessToken"];
             [UBCUserDM saveUserDict:responseObject[@"user"]];
         }
         
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)registerUserWithFields:(NSDictionary *)fields withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider registration]
                                                                andParams:fields];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)verifyEmail:(NSString *)email withCode:(NSString *)code withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider verificationCheck]
                                                                andParams:@{@"code": code,
                                                                            @"email": email,
                                                                            @"type": @"REGISTRATION"}];
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             responseObject = [responseObject removeNulls];
             UBCKeyChain.authorization = responseObject[@"accessToken"];
             [UBCUserDM saveUserDict:responseObject[@"user"]];
         }
         
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)sendVerificationCodeToEmail:(NSString *)email withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider verification]
                                                                andParams:@{@"email": email,
                                                                            @"type": @"PASSWORD"}];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)resetPasswordWithParams:(NSDictionary *)params withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"PASSWORD" forKey:@"type"];
    [dict addEntriesFromDictionary:params];
    
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider verificationCheck]
                                                                andParams:dict];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)logoutWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider logout] andParams:@{@"playerId" : [NSString notEmptyString:[OneSignal getPermissionSubscriptionState].subscriptionStatus.userId]}];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

#pragma mark - USER

- (void)userInfoWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider user]];
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             [UBCUserDM saveUserDict:[responseObject removeNulls]];
         }
         
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)updateUserFields:(NSDictionary *)fields withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider putRequestWithURL:[UBCURLProvider updateUserInfo]
                                                               andParams:fields];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             [UBCUserDM updateUserDict:fields];
         }
         
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

#pragma mark - TRANSACTIONS

- (void)transactionsListWithPageNumber:(NSUInteger)page isETH:(BOOL)isETH withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider transactionsListWithPageNumber:page isETH:isETH];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 UBCTransactionDM *transaction = [[UBCTransactionDM alloc] initWithDictionary:item isETH:isETH];
                 return transaction.rowData;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page + 1);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

#pragma mark - WALLET

- (void)updateBalanceWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider userBalance]];
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             [UBCBalanceDM saveBalanceDict:responseObject];
         }
         
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)topupWithCompletionBlock:(void (^)(BOOL, UBCTopupDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider topup]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCTopupDM *dm = [[UBCTopupDM alloc] initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, dm);
         }
     }];
}

- (void)marketsWithCompletionBlock:(void (^)(BOOL, NSArray *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider markets]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             NSArray *markets = [[responseObject removeNulls] map:^id(id item) {
                 UBTableViewRowData *data = UBTableViewRowData.new;
                 data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                 data.title = item[@"name"];
                 data.iconURL = item[@"icon"];
                 data.data = [NSURL URLWithString:item[@"url"]];
                 return data;
             }];
             completionBlock(success, markets);
         }
     }];
}

- (void)sendCoins:(UBCPaymentDM *)payment withCompletionBlock:(void (^)(BOOL, NSString *, NSString *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider withdraw]
                                                                andParams:payment.requestParams];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, responseObject[@"resultCode"], responseObject[@"message"]);
         }
     }];
}

- (NSURLSessionDataTask *)commissionForAmount:(NSNumber *)amount currency:(NSString *)currency withCompletionBlock:(void (^)(BOOL, NSNumber *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider commissionForAmount:amount currency:currency]];
    return [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, responseObject[@"commission"]);
         }
     }];
}

#pragma mark - CONVERTION

- (NSURLSessionDataTask *)convertFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withAmount:(NSNumber *)amount withCompletionBlock:(void (^)(BOOL, NSNumber *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider convert] andParams:@{@"currencyFrom": fromCurrency, @"currencyTo": toCurrency, @"amount": amount}];
                                                                                                               
    return [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, responseObject[@"amount"]);
         }
     }];
}

#pragma mark - FAVORITES

- (void)favoritesListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider favoritesListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 UBCGoodDM *good = [[UBCGoodDM alloc] initWithDictionary:item];
                 UBTableViewRowData *data = good.rowData;
                 data.className = NSStringFromClass(UBCFavouriteCell.class);
                 return data;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page + 1);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

- (void)toggleFavoriteWithID:(NSString *)favoriteID isFavorite:(BOOL)isFavorite
{
    NSURL *url = [UBCURLProvider favoriteWithID:favoriteID];
    
    NSMutableURLRequest *request;
    if (isFavorite)
    {
        request = [UBCRequestProvider postRequestWithURL:url andParams:nil];
    }
    else
    {
        request = [UBCRequestProvider deleteRequestWithURL:url];
    }
    
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:nil];
}

#pragma mark - DEALS

- (void)dealsToSellWithCompletionBlock:(void (^)(BOOL, NSArray *))completionBlock
{
    NSURL *url = [UBCURLProvider dealsToSell];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *activeItems = [responseObject[@"active"] removeNulls];
             activeItems = [activeItems map:^id(id item) {
                 UBCGoodDM *good = [[UBCGoodDM alloc] initWithDictionary:item];
                 UBTableViewRowData *data = good.rowData;
                 data.className = NSStringFromClass(UBCDealCell.class);
                 return data;
             }];
             
             NSArray *notActiveItems = [responseObject[@"waste"] removeNulls];
             notActiveItems = [notActiveItems map:^id(id item) {
                 UBCGoodDM *good = [[UBCGoodDM alloc] initWithDictionary:item];
                 UBTableViewRowData *data = good.rowData;
                 data.className = NSStringFromClass(UBCDealCell.class);
                 data.isSelected = YES;
                 return data;
             }];
             
             NSMutableArray *sections = [NSMutableArray array];
             
             if (activeItems.count > 0)
             {
                 UBTableViewSectionData *section = UBTableViewSectionData.new;
                 section.headerTitle = UBLocalizedString(@"str_item_status_active", nil);
                 section.rows = activeItems;
                 
                 [sections addObject:section];
             }
             
             if (notActiveItems.count > 0)
             {
                 UBTableViewSectionData *section = UBTableViewSectionData.new;
                 section.headerTitle = UBLocalizedString(@"str_item_status_not_active", nil);
                 section.rows = notActiveItems;
                 
                 [sections addObject:section];
             }
             
             if (completionBlock)
             {
                 completionBlock(YES, sections);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil);
         }
     }];
}

- (void)dealsToBuyWithCompletionBlock:(void (^)(BOOL, NSArray *))completionBlock
{
    NSURL *url = [UBCURLProvider dealsToBuy];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *activeItems = [responseObject[@"active"] removeNulls];
             activeItems = [activeItems map:^id(id item) {
                 UBCDealDM *deal = [[UBCDealDM alloc] initWithDictionary:item];
                 UBTableViewRowData *data = deal.rowData;
                 data.className = NSStringFromClass(UBCDealCell.class);
                 return data;
             }];
             
             NSArray *notActiveItems = [responseObject[@"waste"] removeNulls];
             notActiveItems = [notActiveItems map:^id(id item) {
                 UBCDealDM *deal = [[UBCDealDM alloc] initWithDictionary:item];
                 UBTableViewRowData *data = deal.rowData;
                 data.className = NSStringFromClass(UBCDealCell.class);
                 data.isDisabled = deal.item.status != UBCItemStatusActive;
                 return data;
             }];
             
             NSMutableArray *sections = [NSMutableArray array];
             
             if (activeItems.count > 0)
             {
                 UBTableViewSectionData *section = UBTableViewSectionData.new;
                 section.headerTitle = UBLocalizedString(@"str_item_status_active", nil);
                 section.rows = activeItems;
                 
                 [sections addObject:section];
             }
             
             if (notActiveItems.count > 0)
             {
                 UBTableViewSectionData *section = UBTableViewSectionData.new;
                 section.headerTitle = UBLocalizedString(@"str_item_status_not_active", nil);
                 section.rows = notActiveItems;
                 
                 [sections addObject:section];
             }
             
             if (completionBlock)
             {
                 completionBlock(YES, sections);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil);
         }
     }];
}

#pragma mark - CHAT

- (void)dealForItemID:(NSString *)itemID withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider deal]
                                                                andParams:@{@"itemId": itemID}];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, [[UBCDealDM alloc] initWithDictionary:[responseObject removeNulls]]);
         }
     }];
}

- (void)dealsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider dealsListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"content"] removeNulls];
             items = [items map:^id(id item) {
                 UBCDealDM *deal = [[UBCDealDM alloc] initWithDictionary:item];
                 return deal.rowData;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = responseObject[@"totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page + 1 );
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}
    
- (void)chartDealsListWithCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider chartDealsList];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success && ((NSArray *)responseObject).count > 0)
         {
             NSArray *items = [responseObject removeNulls];
             items = [items map:^id(id item) {
                 UBCChatRoom *chatRoom = [[UBCChatRoom alloc] initWithDictionary:item];
                 return [chatRoom rowData];
             }];
             
             if (completionBlock)
             {
                 completionBlock(YES, items, NO);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

#pragma mark - ITEM CREATION

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void (^)(BOOL, NSString *))completionBlock
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    NSString *base64 = [UBBase64 encode:imageData];
    
    NSString *name = [NSString stringWithFormat:@"%li", (long)NSDate.date.timeIntervalSince1970];
    
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider uploadImage] andParams:base64 ? @{@"name": name, @"data": base64} : @{}];

    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, responseObject[@"url"]);
         }
     }];
}

- (void)sellItem:(NSDictionary *)dictionary withCompletionBlock:(void (^)(BOOL, UBCGoodDM *))completionBlock
{
    NSMutableDictionary *full = dictionary.mutableCopy;
    full[@"agreement"] = @"true";
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider sellItem] andParams:full.copy];
    if (dictionary[@"id"])
    {
        request = [UBCRequestProvider putRequestWithURL:[UBCURLProvider sellItem] andParams:full.copy];
    }
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCGoodDM *item;
             if (success)
             {
                 item = [UBCGoodDM.alloc initWithDictionary:[responseObject removeNulls]];
             }
             completionBlock(success, item);
         }
     }];
}

#pragma mark - PURCHASE

- (void)buyItem:(NSString *)itemID isDelivery:(BOOL)isDelivery currency:(NSString *)currency withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider buyItem]
                                                                andParams:@{@"itemId": itemID,
                                                                            @"withDelivery": @(isDelivery),
                                                                            @"currencyType": currency}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
             
             // need this for update purchase
//
//             [self checkStatusForDeal:deal.ID withCompletionBlock:^(BOOL success, id responseObject)
//              {
//                  completionBlock(success, responseObject);
//              }];
             
             
         }
     }];
}

- (void)cancelDeal:(NSString *)dealID withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider cancelDeal:dealID] andParams:@{}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)confirmDeal:(NSString *)dealID withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider confirmDeal:dealID] andParams:@{}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

- (void)checkStatusForDeal:(NSString *)dealID withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider checkStatusForDeal:dealID]];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

- (void)changePersonalMeetingToDeliveryForDeal:(NSString *)dealID withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider changePersonalMeetingToDeliveryForDeal:dealID] andParams:@{}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

- (void)setDeliveryPriceForDeal:(NSString *)dealID price:(NSString *)price withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider setDeliveryPriceForDeal:dealID] andParams:@{@"amount": [NSString notEmptyString:price]}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

- (void)confirmDeliveryPriceForDeal:(NSString *)dealID price:(NSString *)price withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider confirmDeliveryPriceForDeal:dealID] andParams:@{@"amount": [NSString notEmptyString:price]}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

- (void)startDeliveryForDeal:(NSString *)dealID withCompletionBlock:(void (^)(BOOL, UBCDealDM *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider startDeliveryForDeal:dealID] andParams:@{}];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             UBCDealDM *deal = [UBCDealDM.alloc initWithDictionary:[responseObject removeNulls]];
             completionBlock(success, deal);
         }
     }];
}

#pragma mark - APNS

- (void)subscribeAPNS
{
    NSString *playerID = [OneSignal getPermissionSubscriptionState].subscriptionStatus.userId;
    if ([playerID isNotEmpty])
    {
        NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider subscribeAPNS]
                                                                    andParams:@{@"playerId": playerID}];
        [self.connection sendRequest:request isBackground:NO withCompletionBlock:nil];
    }
}

@end

