//
//  UBCURLProvider.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCURLProvider.h"

#define SERVER_URL @"https://my.ubcoin.io/api/"
#define ITEMS_PAGE_SIZE 15

@implementation UBCURLProvider

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items?page=%d&size=%d", (int)page, ITEMS_PAGE_SIZE];
    return [NSURL URLWithString:url];
}

+ (NSURL *)categories
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/categories"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)login
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"auth"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)logout
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"auth/logout"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)registration
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users/registration"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)verification
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"verification"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)verificationCheck
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"verification/check"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)user
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users/me"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)updateUserInfo
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)userBalance
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/balance"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)convert
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/convert"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)comission
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/comission"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)withdraw
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/withdraw"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)topup
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/topup"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)transactionsListWithPageNumber:(NSUInteger)page
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/transactions?page=%d&size=%d", (int)page, ITEMS_PAGE_SIZE];
    return [NSURL URLWithString:url];
}

+ (NSURL *)favoriteWithID:(NSString *)favoriteID
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"favorites/%@", favoriteID];
    return [NSURL URLWithString:url];
}

+ (NSURL *)favoritesListWithPageNumber:(NSUInteger)page
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"favorites?page=%d&size=%d", (int)page, ITEMS_PAGE_SIZE];
    return [NSURL URLWithString:url];
}

+ (NSURL *)dealsToSellListWithPageNumber:(NSUInteger)page
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"purchases/seller?page=%d&size=%d", (int)page, ITEMS_PAGE_SIZE];
    return [NSURL URLWithString:url];
}

+ (NSURL *)dealsToBuyListWithPageNumber:(NSUInteger)page
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"purchases/buyer?page=%d&size=%d", (int)page, ITEMS_PAGE_SIZE];
    return [NSURL URLWithString:url];
}

+ (NSURL *)chatURLForItemID:(NSString *)itemID
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users/tg?itemId=%@", itemID];
    return [NSURL URLWithString:url];
}

+ (NSURL *)uploadImage
{
    NSString *url = [SERVER_URL stringByAppendingString:@"images"];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)sellItem
{
    NSString *url = [SERVER_URL stringByAppendingString:@"items"];
    
    return [NSURL URLWithString:url];
}

@end
