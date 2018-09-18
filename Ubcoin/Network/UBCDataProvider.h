//
//  UBCDataProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UBCGoodDM;
@class UBCTopupDM;
@interface UBCDataProvider : NSObject

@property (class, nonatomic, readonly) UBCDataProvider *sharedProvider;

- (void)goodsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;
- (void)discountsWithCompletionBlock:(void (^)(BOOL success, NSArray *discounts))completionBlock;

- (void)activateItem:(NSString *)itemID withCompletionBlock:(void (^)(BOOL success, UBCGoodDM *item))completionBlock;
- (void)deactivateItem:(NSString *)itemID withCompletionBlock:(void (^)(BOOL success, UBCGoodDM *item))completionBlock;

- (void)categoriesWithCompletionBlock:(void (^)(BOOL success, NSArray *categories))completionBlock;

- (void)loginWithEmail:(NSString *)email password:(NSString *)password withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)registerUserWithFields:(NSDictionary *)fields withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)verifyEmail:(NSString *)email withCode:(NSString *)code withCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)sendVerificationCodeToEmail:(NSString *)email withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)resetPasswordWithParams:(NSDictionary *)params withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)logoutWithCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)userInfoWithCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)updateUserFields:(NSDictionary *)fields withCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)transactionsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;

- (void)updateBalanceWithCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)topupWithCompletionBlock:(void (^)(BOOL success, UBCTopupDM *topup))completionBlock;
- (void)marketsWithCompletionBlock:(void (^)(BOOL success, NSArray *markets))completionBlock;
- (void)sendCoins:(NSNumber *)amount toAddress:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSString *result, NSString *message))completionBlock;
- (NSURLSessionDataTask *)commissionForAmount:(NSNumber *)amount withCompletionBlock:(void (^)(BOOL success, NSNumber *commission))completionBlock;
- (NSURLSessionDataTask *)convertFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withAmount:(NSNumber *)amount withCompletionBlock:(void (^)(BOOL success, NSNumber *amountInCurrency))completionBlock;

- (void)favoritesListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;
- (void)toggleFavoriteWithID:(NSString *)favoriteID isFavorite:(BOOL)isFavorite;

- (void)dealsToSellListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *items, BOOL canLoadMore))completionBlock;
- (void)dealsToBuyListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *deals, BOOL canLoadMore))completionBlock;

- (void)chatURLForItemID:(NSString *)itemID withCompletionBlock:(void (^)(BOOL success, NSURL *url, NSURL *appURL))completionBlock;
- (void)chatURLForDealID:(NSString *)dealID withCompletionBlock:(void (^)(BOOL, NSURL *, NSURL *))completionBlock;
- (void)registerInChatWithCompletionBlock:(void (^)(BOOL success, BOOL authorized, NSURL *url, NSURL *appURL))completionBlock;

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void (^)(BOOL success, NSString *url))completionBlock;
- (void)sellItem:(NSDictionary *)dictionary withCompletionBlock:(void (^)(BOOL success))completionBlock;

@end
