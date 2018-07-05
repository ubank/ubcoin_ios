//
//  UBCURLProvider.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCURLProvider.h"

#define SERVER_URL @"https://private-anon-c5ab7ff20b-ubcoinapi.apiary-mock.com/api/"

@implementation UBCURLProvider

+ (NSURL *)goodsListWithPageNumber:(NSUInteger)page
{
    NSString* url = [SERVER_URL stringByAppendingFormat:@"items?page=%d&size=15", (int)page];
    return [NSURL URLWithString:url];
}

@end
