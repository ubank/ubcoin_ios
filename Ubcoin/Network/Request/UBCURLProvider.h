//
//  UBCURLProvider.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCURLProvider : NSObject

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page;
+ (NSURL *)categories;

+ (NSURL *)login;
+ (NSURL *)logout;
+ (NSURL *)registration;

+ (NSURL *)user;
+ (NSURL *)userBalance;

+ (NSURL *)favoriteWithID:(NSString *)favoriteID;
+ (NSURL *)favoritesListWithPageNumber:(NSUInteger)page;

+ (NSURL *)dealsToSellListWithPageNumber:(NSUInteger)page;
+ (NSURL *)dealsToBuyListWithPageNumber:(NSUInteger)page;

@end
