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
+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page forSeller:(NSString *)sellerID;
+ (NSURL *)goodsCountWithFilters:(NSString *)filters;
+ (NSURL *)categories;
+ (NSURL *)activateItem;
+ (NSURL *)deactivateItem;
+ (NSURL *)goodWithID:(NSString *)itemID;
+ (NSURL *)sellerWithID:(NSString *)sellerID;

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
+ (NSURL *)commissionForAmount:(NSNumber *)amount currency:(NSString *)currency;
+ (NSURL *)withdraw;
+ (NSURL *)topup;
+ (NSURL *)markets;

+ (NSURL *)transactionsListWithPageNumber:(NSUInteger)page isETH:(BOOL)isETH;

+ (NSURL *)favoriteWithID:(NSString *)favoriteID;
+ (NSURL *)favoritesListWithPageNumber:(NSUInteger)page;

+ (NSURL *)dealsToSell;
+ (NSURL *)dealsToBuy;

+ (NSURL *)deal;
+ (NSURL *)dealsListWithPageNumber:(NSUInteger)page;
    
+ (NSURL *) chartDealsList;

+ (NSURL *)uploadImage;
+ (NSURL *)sellItem;

+ (NSURL *)buyItem;
+ (NSURL *)cancelDeal:(NSString *)dealID;
+ (NSURL *)confirmDeal:(NSString *)dealID;

+ (NSURL *)checkStatusForDeal:(NSString *)dealID;

+ (NSURL *)changePersonalMeetingToDeliveryForDeal:(NSString *)dealID;
+ (NSURL *)setDeliveryPriceForDeal:(NSString *)dealID;
+ (NSURL *)confirmDeliveryPriceForDeal:(NSString *)dealID;
+ (NSURL *)startDeliveryForDeal:(NSString *)dealID;

@end
