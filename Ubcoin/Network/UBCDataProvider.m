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
#import "UBCDiscountDM.h"
#import "UBCCategoryDM.h"
#import "UBCTransactionDM.h"
#import "UBCKeyChain.h"

#import "UBCFavouriteCell.h"

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

- (void)goodsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider goodsListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
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
                 completionBlock(YES, items, totalPages.integerValue > page);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

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
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider logout] andParams:nil];
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

- (void)transactionsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider transactionsListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 UBCTransactionDM *deal = [[UBCTransactionDM alloc] initWithDictionary:item];
                 return deal.rowData;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
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
                 completionBlock(YES, items, totalPages.integerValue > page);
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

- (void)dealsToSellListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider dealsToSellListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 UBCDealDM *deal = [[UBCDealDM alloc] initWithDictionary:item];
                 return deal.rowData;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

- (void)dealsToBuyListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL, NSArray *, BOOL))completionBlock
{
    NSURL *url = [UBCURLProvider dealsToBuyListWithPageNumber:page];
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:url];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (success)
         {
             NSArray *items = [responseObject[@"data"] removeNulls];
             items = [items map:^id(id item) {
                 UBCDealDM *deal = [[UBCDealDM alloc] initWithDictionary:item];
                 return deal.rowData;
             }];
             
             if (completionBlock)
             {
                 NSNumber *totalPages = [responseObject valueForKeyPath:@"pageData.totalPages"];
                 completionBlock(YES, items, totalPages.integerValue > page);
             }
         }
         else if (completionBlock)
         {
             completionBlock(NO, nil, YES);
         }
     }];
}

#pragma mark - CHAT

- (void)chatURLForItemID:(NSString *)itemID withCompletionBlock:(void (^)(BOOL, NSURL *))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider getRequestWithURL:[UBCURLProvider chatURLForItemID:itemID]];
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success, [NSURL URLWithString:responseObject[@"url"]]);
         }
     }];
}

#pragma mark - BALANCE

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

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider uploadImage] andParams:nil];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = UIImageJPEGRepresentation(image, 0.7);
    
    [self.connection sendRequest:request isBackground:YES withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

- (void)sellItem:(NSDictionary *)dictionary withCompletionBlock:(void (^)(BOOL))completionBlock
{
    NSMutableDictionary *full = dictionary.mutableCopy;
    full[@"agreement"] = @"true";
    
    NSMutableURLRequest *request = [UBCRequestProvider postRequestWithURL:[UBCURLProvider sellItem] andParams:full.copy];
    
    [self.connection sendRequest:request isBackground:NO withCompletionBlock:^(BOOL success, id responseObject)
     {
         if (completionBlock)
         {
             completionBlock(success);
         }
     }];
}

@end

