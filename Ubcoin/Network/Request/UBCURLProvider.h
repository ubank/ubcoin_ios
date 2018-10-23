//
//  UBCURLProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCURLProvider : NSObject

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page andFilters:(NSString *)filters;
+ (NSURL *)goodsCountWithFilters:(NSString *)filters;
+ (NSURL *)categories;
+ (NSURL *)activateItem;
+ (NSURL *)deactivateItem;
+ (NSURL *)goodWithID:(NSString *)itemID;

+ (NSURL *)login;
+ (NSURL *)logout;
+ (NSURL *)registration;
+ (NSURL *)verification;
+ (NSURL *)verificationCheck;
+ (NSURL *)registrationInChat;

+ (NSURL *)user;
+ (NSURL *)updateUserInfo;
+ (NSURL *)userBalance;

+ (NSURL *)convert;
+ (NSURL *)commissionForAmount:(NSNumber *)amount;
+ (NSURL *)withdraw;
+ (NSURL *)topup;
+ (NSURL *)markets;

+ (NSURL *)transactionsListWithPageNumber:(NSUInteger)page;

+ (NSURL *)favoriteWithID:(NSString *)favoriteID;
+ (NSURL *)favoritesListWithPageNumber:(NSUInteger)page;

+ (NSURL *)dealsToSellListWithPageNumber:(NSUInteger)page;
+ (NSURL *)dealsToBuyListWithPageNumber:(NSUInteger)page;

+ (NSURL *)chatURL;

+ (NSURL *)uploadImage;
+ (NSURL *)sellItem;

@end
