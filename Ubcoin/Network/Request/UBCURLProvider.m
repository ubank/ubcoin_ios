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

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page andFilters:(NSString *)filters
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items?page=%d&size=%d%@", (int)page, ITEMS_PAGE_SIZE, [NSString notEmptyString:filters]];
    url = [self addUserLocationToURL:url];
    return [NSURL URLWithString:url];
}

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page forSeller:(NSString *)sellerID
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items?page=%d&size=%d&sellerId=%@", (int)page, ITEMS_PAGE_SIZE, sellerID];
    url = [self addUserLocationToURL:url];
    return [NSURL URLWithString:url];
}

+ (NSURL *)goodsCountWithFilters:(NSString *)filters
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/count"];
    url = [self appendFilters:filters toURL:url];
    url = [self addUserLocationToURL:url];
    return [NSURL URLWithString:url];
}

+ (NSURL *)goodWithID:(NSString *)itemID
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/%@", itemID];
    url = [self addUserLocationToURL:url];
    return [NSURL URLWithString:url];
}

+ (NSURL *)sellerWithID:(NSString *)sellerID
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users/seller?id=%@", sellerID];
    return [NSURL URLWithString:url];
}

+ (NSURL *)categories
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/categories"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)activateItem
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/activate"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)deactivateItem
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/deactivate"];
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

+ (NSURL *)registrationInChat
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"users/tg"];
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

+ (NSURL *)commissionForAmount:(NSNumber *)amount currency:(NSString *)currency
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/commission?amount=%@&currencyType=%@", amount, currency];
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

+ (NSURL *)markets
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/markets"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)transactionsListWithPageNumber:(NSUInteger)page isETH:(BOOL)isETH
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"wallet/transactions?page=%d&size=%d&currencyType=%@", (int)page, ITEMS_PAGE_SIZE, isETH ? @"ETH" : @"UBC"];
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

+ (NSURL *)chatURL
{
    NSString *url = [SERVER_URL stringByAppendingFormat:@"items/discuss"];
    return [NSURL URLWithString:url];
}

+ (NSURL *)uploadImage
{
    NSString *url = [SERVER_URL stringByAppendingString:@"images/base64"];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)sellItem
{
    NSString *url = [SERVER_URL stringByAppendingString:@"items"];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)subscribeAPNS
{
    NSString *url = [SERVER_URL stringByAppendingString:@"notify/push-subscribe"];
    
    return [NSURL URLWithString:url];
}

#pragma mark -

+ (NSString *)addUserLocationToURL:(NSString *)url
{
    CLLocation *location = UBLocationManager.sharedLocation.lastLocation;
    if (location)
    {
        url = [url stringByAppendingString:[url containsString:@"?"] ? @"&" : @"?"];
        url = [url stringByAppendingFormat:@"latPoint=%f&longPoint=%f", location.coordinate.latitude, location.coordinate.longitude];
    }
    
    return url;
}

+ (NSString *)appendFilters:(NSString *)filters toURL:(NSString *)url
{
    if (filters.isNotEmpty)
    {
        if (![url containsString:@"?"] &&
            [filters hasPrefix:@"&"])
        {
            filters = [filters stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                       withString:@"?"];
        }
        
        url = [url stringByAppendingString:filters];
    }
    
    return url;
}

@end
