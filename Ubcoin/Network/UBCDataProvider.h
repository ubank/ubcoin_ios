//
//  UBCDataProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCDataProvider : NSObject

@property (class, nonatomic, readonly) UBCDataProvider *sharedProvider;

- (void)goodsListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;
- (void)discountsWithCompletionBlock:(void (^)(BOOL success, NSArray *discounts))completionBlock;

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

- (void)topupWithCompletionBlock:(void (^)(BOOL success, NSString *qrCodeURL, NSString *address))completionBlock;
- (void)sendCoins:(NSNumber *)amount toAddress:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSNumber *result, NSString *message))completionBlock;
- (void)commissionForAmount:(NSNumber *)amount withCompletionBlock:(void (^)(BOOL success, NSNumber *commission))completionBlock;
- (void)convertFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withAmount:(NSNumber *)amount withCompletionBlock:(void (^)(BOOL success, NSNumber *amountInCurrency))completionBlock;

- (void)favoritesListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;
- (void)toggleFavoriteWithID:(NSString *)favoriteID isFavorite:(BOOL)isFavorite;

- (void)dealsToSellListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *deals, BOOL canLoadMore))completionBlock;
- (void)dealsToBuyListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *deals, BOOL canLoadMore))completionBlock;

- (void)chatURLForItemID:(NSString *)itemID withCompletionBlock:(void (^)(BOOL success, NSURL *url, NSURL *appURL))completionBlock;
- (void)registerInChatWithCompletionBlock:(void (^)(BOOL success, NSURL *url, NSURL *appURL))completionBlock;

- (void)updateBalanceWithCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)uploadImage:(UIImage *)image withCompletionBlock:(void (^)(BOOL success, NSString *url))completionBlock;
- (void)sellItem:(NSDictionary *)dictionary withCompletionBlock:(void (^)(BOOL success))completionBlock;

@end
