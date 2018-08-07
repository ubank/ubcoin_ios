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
- (void)verifyEmailWithCode:(NSString *)code withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)resendPasswordForEmail:(NSString *)email withCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)logoutWithCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)userInfoWithCompletionBlock:(void (^)(BOOL success))completionBlock;
- (void)userBalanceWithCompletionBlock:(void (^)(BOOL success))completionBlock;

- (void)favoritesListWithPageNumber:(NSUInteger)page withCompletionBlock:(void (^)(BOOL success, NSArray *goods, BOOL canLoadMore))completionBlock;
- (void)toggleFavoriteWithID:(NSString *)favoriteID isFavorite:(BOOL)isFavorite;

@end
