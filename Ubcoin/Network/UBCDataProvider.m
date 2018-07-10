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
#import "UBCDiscountDM.h"
#import "UBCCategoryDM.h"

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
        UBCDiscountDM *discount1 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"Apple stuff",
                                                                               @"description": @"Celebrate 10 years of iPhone",
                                                                               @"image": @"ad_banner_1"}];
        UBCDiscountDM *discount2 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"New bicycle",
                                                                               @"description": @"Just take a ride",
                                                                               @"image": @"ad_banner_2"}];
        UBCDiscountDM *discount3 = [[UBCDiscountDM alloc] initWithDictionary:@{@"title": @"Interior",
                                                                               @"description": @"Bright and modern details",
                                                                               @"image": @"ad_banner_3"}];
        completionBlock(YES, @[discount1, discount2, discount3]);
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

@end
