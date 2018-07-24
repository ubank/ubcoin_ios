//
//  UBCGoodDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodDM.h"

#define FAVORITE_KEY @"favourite goods"
#define ALL_GOODS_KEY @"all goods"

@implementation UBCGoodDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _title = dict[@"title"];
        _desc = dict[@"description"];
        _locationText = [dict valueForKeyPath:@"location.text"];
        _price = dict[@"price"];
//        _isFavorite = dict[@"is_favorite"];
        _isFavorite = [UBCGoodDM isFavorite:self.ID];
        _creationDate = [NSDate dateFromISO8601String:dict[@"createdDate"]];
        _images = dict[@"images"];
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"user"]];
        _category = [[UBCCategoryDM alloc] initWithDictionary:dict[@"category"]];
        
        _dict = dict;
    }
    return self;
}

- (void)toggleFavorite
{
    _isFavorite = !self.isFavorite;
    
    NSMutableDictionary *dict = [self.dict mutableCopy];
    [dict setObject:@(self.isFavorite) forKey:@"is_favorite"];

    NSMutableArray *favorites = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY] mutableCopy];
    if (!favorites)
    {
        favorites = [NSMutableArray array];
    }
    
    if (self.isFavorite)
    {
        [favorites addObject:dict];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != %@", dict[@"id"]];
        [favorites filterUsingPredicate:predicate];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:FAVORITE_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFavoritesChanged object:nil];
}

#pragma mark -

+ (NSArray *)favorites
{
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY];
    return [favorites map:^id(id item) {
        return [[UBCGoodDM alloc] initWithDictionary:item];
    }];
}

+ (BOOL)isFavorite:(NSString *)itemID
{
    if (itemID)
    {
        NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_KEY];
        NSArray *favIDs = [favorites valueForKey:@"id"];
        return [favIDs containsObject:itemID];
    }
    return NO;
}

+ (void)saveGoods:(NSArray *)goods
{
    if (goods)
    {
        NSArray *dicts = [goods valueForKey:@"dict"];
        [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:ALL_GOODS_KEY];
    }
}

+ (NSArray *)relatedGoods
{
    NSArray *goods = [[NSUserDefaults standardUserDefaults] objectForKey:ALL_GOODS_KEY];
    
    NSMutableSet *set = [NSMutableSet set];
    if (goods.count > 1)
    {
        for (int i = 0; i < 4; i++)
        {
            [set addObject:goods[arc4random() % [goods count]]];
        }
    }
    return [[set allObjects] map:^id(id item) {
        return [[UBCGoodDM alloc] initWithDictionary:item];
    }];
}

@end
